# Abschnitt 1: Die Basis festlegen
# ================================
FROM jenkins/inbound-agent:latest-jdk21

# Abschnitt 2: Zu Administrator-Rechten wechseln
# ==============================================
# Notwendig, um Software zu installieren.
USER root

# Abschnitt 3: Notwendige Werkzeuge und Pakete installieren
# =========================================================
RUN apt-get update && apt-get install -y git apt-transport-https ca-certificates curl gnupg

# Abschnitt 4: Richte das Docker-Repository ein
# =============================================
# Füge den offiziellen GPG-Schlüssel von Docker hinzu
RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN chmod a+r /etc/apt/keyrings/docker.gpg
# Richte das Docker-Repository ein
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Abschnitt 6: Installation des Docker Clients
# ============================================
RUN apt-get update
# Installiere nur den Docker-Client (CLI)
RUN apt-get install -y docker-ce-cli

# Abschnitt 8: Zurück zum sicheren Standard-Benutzer wechseln
# ===========================================================
# Wichtiger Sicherheitsschritt am Ende aller Installationen.
USER jenkins
