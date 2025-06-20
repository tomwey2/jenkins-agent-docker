# Abschnitt 1: Die Basis festlegen
# ================================
FROM jenkins/inbound-agent:latest-jdk21

# Abschnitt 2: Zu Administrator-Rechten wechseln
# ==============================================
# Notwendig, um Software zu installieren.
USER root

# Abschnitt 3: Installation der Abhängigkeiten (Kombiniert und Erweitert)
# =======================================================================
# Wir aktualisieren die Paketliste erneut, um die neuen Quellen (Docker & Java) einzulesen.
RUN apt-get update && apt-get install -y git apt-transport-https ca-certificates curl gnupg wget

# Abschnitt 4: Richte das Docker-Repository ein
# =============================================
# Füge den offiziellen GPG-Schlüssel von Docker hinzu
RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN chmod a+r /etc/apt/keyrings/docker.gpg
# Richte das Docker-Repository ein
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Abschnitt 6: Installation der finalen Pakete (Docker CLI & Java 21)
# ===================================================================
RUN apt-get update
# Installiere nur den Docker-Client (CLI)
RUN apt-get install -y docker-ce-cli

# Abschnitt 8: Zurück zum sicheren Standard-Benutzer wechseln
# ===========================================================
# Wichtiger Sicherheitsschritt am Ende aller Installationen.
USER jenkins
