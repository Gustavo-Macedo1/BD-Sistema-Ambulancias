import streamlit as st
import time
from persistence import *

st.title("🚑 Sistema de Despacho de Ambulâncias - CRUD")
st.divider()

cnx = connect_bd()

st.subheader("Visualização das tabelas")

tab1, tab2, tab3, tab4, tab5, tab6, tab7, tab8, tab9, tab10, tab11 = st.tabs(["Administrador", "Ambulância", "Atendimento", "Chamado", "Despacho", "Equipe", "Hospital", "Paciente", "Rastreamento", "Status Ambulância", "Tipo Ambulância"])

tabs = [tab1, tab2, tab3, tab4, tab5, tab6, tab7, tab8, tab9, tab10, tab11]
names = ['administrador', 'ambulancia', 'atendimento', 'chamado', 'despacho', 'equipe', 'hospital', 'paciente', 'rastreamento', 'statusambulancia', 'tipoambulancia']

for tab in tabs:
    with tab:
        # Mostrando tabela completa
        name = names[tabs.index(tab)]
        df = select_all_df(cnx, name) 
        st.write(df)

        # Menu de operações CRUD
        st.subheader("Operações CRUD")

        options = ["Criar", "Atualizar", "Deletar"]
        selection = st.segmented_control(
            "Operações disponíveis:", options, selection_mode="single", key=f"segmented_control_{tabs.index(tab)}"
        )

        # Para cada operação, cria campos correspondentes para a query
        if selection == "Criar":
            query = f"INSERT INTO {name} ("
            options = st.multiselect(
                "Selecione as colunas para inserir dados:",
                df.columns[1:],
                )
            query += ", ".join(list(options)) + ") VALUES ("

            values = []
            for option in options:
                if option == 'foto':
                    file = st.file_uploader(f"Faça upload da imagem para {option}:", type=['png', 'jpg', 'jpeg'], key=f"{option}_uploader_{tabs.index(tab)}")
                    if file:
                        value = file.read() # Valor já em bytes
                else:
                    value = st.text_input(f"Insira o valor para {option}:", key=f"{option}_input_{tabs.index(tab)}")
                query += "%s, "
                values.append(value)

            query = query.rstrip(", ") + ");"
            values = tuple(values)

            if st.button("Executar Criação", key=f"create_button_{tabs.index(tab)}"):
                create(cnx, query, values)
                st.success("Registro criado com sucesso!")
                time.sleep(2)
                st.rerun()

        elif selection == "Atualizar":
            query = f"UPDATE {name} SET "
            values = []
            id = st.selectbox("Selecione o ID da linha a ser atualizada:", df[df.columns[0]].tolist(), key=f"update_id_select_{tabs.index(tab)}")
            
            st.markdown("**Insira os novos valores para as colunas desejadas (preencha apenas os campos que deseja alterar):**")
            
            for column in df.columns[1:]:
                if column == 'foto':
                    file = st.file_uploader(f"Coluna: {column}:", type=['png', 'jpg', 'jpeg'], key=f"{column}_uploader_{tabs.index(tab)}")
                    if file:
                        new_value = file.read() # Valor já em bytes
                else:
                    new_value = st.text_input(f"Coluna: {column}", key=f"update_{column}_input_{tabs.index(tab)}")
                
                if new_value:
                    query += f"{column} = %s, "
                    values.append(new_value)
            
            query = query.rstrip(", ") + " WHERE " + df.columns[0] + f" = {id};"
            
            if st.button("Executar Atualização", key=f"update_button_{tabs.index(tab)}"):
                update(cnx, query, values)
                st.success("Registro atualizado com sucesso!")
                time.sleep(2)
                st.rerun()

        elif selection == "Deletar":
            id = st.selectbox("Selecione o ID da linha a ser deletada:", df[df.columns[0]].tolist(), key=f"update_id_select_{tabs.index(tab)}")

            query = f"DELETE FROM {name} WHERE " + df.columns[0] + f" = {id};"
            if st.button("Executar Deleção", key=f"delete_button_{tabs.index(tab)}"):
                delete(cnx, query)
                st.success("Registro deletado com sucesso!")
                time.sleep(2)
                st.rerun()
        

