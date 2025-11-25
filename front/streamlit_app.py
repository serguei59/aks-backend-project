import os
import streamlit as st
import requests

# ============================
# CONFIGURATION
# ============================

# Mode d'accès API : "internal" ou "ingress"
API_MODE = os.getenv("API_MODE", "internal").lower()

# Namespace pour l'accès interne
NAMESPACE = os.getenv("NAMESPACE", "sbuasa")

# API URL interne (DNS Kubernetes)
INTERNAL_API_URL = f"http://api.{NAMESPACE}.svc.cluster.local:5000"

# API URL via Ingress (publique)
# Exemple : http://<EXTERNAL-IP>/sbuasa-api
INGRESS_API_URL = os.getenv("API_URL")  # obligatoire en mode ingress

# Sélection de l'URL selon mode
if API_MODE == "ingress":
    if not INGRESS_API_URL:
        st.error("API_MODE=ingress mais API_URL est vide.")
        st.stop()
    
    # Préfixe API INGRESS → /api
    API_URL = f"{INGRESS_API_URL}/api"
else:
    API_URL = INTERNAL_API_URL


# ============================
# UI STREAMLIT
# ============================
st.title("Clients Dashboard")
st.caption(f"Mode API : {API_MODE} → {API_URL}")

# -------- HEALTH CHECK --------
st.subheader("Statut de l'API")
try:
    res = requests.get(f"{API_URL}/health")
    st.success(res.json())
except Exception as e:
    st.error(f"Erreur API: {e}")

# -------- LISTE CLIENTS --------
st.subheader("Liste des clients")
try:
    res = requests.get(f"{API_URL}/clients")
    clients = res.json()
    st.write(clients)
except Exception as e:
    st.error(f"Erreur API: {e}")

# -------- AJOUT CLIENT --------
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
        try:
            r = requests.post(f"{API_URL}/clients", json=payload)
            st.success(r.json())
        except Exception as e:
            st.error(f"Erreur POST: {e}")

# -------- SUPP CLIENT --------
st.subheader("Supprimer un client")
with st.form("delete_client"):
    client_id = st.text_input("ID du client à supprimer")
    submitted = st.form_submit_button("Supprimer")
    if submitted:
        try:
            r = requests.delete(f"{API_URL}/clients/{client_id}")
            st.success(r.json())
        except Exception as e:
            st.error(f"Erreur DELETE: {e}")

