# app/streamlit_app.py
import streamlit as st
import requests

#API_URL = "http://localhost:30000/clients"
API_URL = "http://api-service:8000/clients"

st.title("Clients Dashboard")

st.subheader("Liste des clients")
try:
    res = requests.get(API_URL)
    clients = res.json()
    st.write(clients)
except Exception as e:
    st.error(f"Erreur API: {e}")

st.subheader("Ajouter un client")
with st.form("add_client"):
    first_name = st.text_input("Prénom")
    last_name = st.text_input("Nom")
    email = st.text_input("Email")
    submitted = st.form_submit_button("Ajouter")
    if submitted:
        payload = {
            "first_name": first_name,
            "last_name": last_name,
            "email": email
        }
        r = requests.post(API_URL, json=payload)
        st.write(r.json())
