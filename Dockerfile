# Abschnitt 1: Die Basis festlegen
# ================================
FROM jenkins/inbound-agent

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

# Abschnitt 5: Sichere Einrichtung des Java 21 Repositorys (Eclipse Temurin/Adoptium)
# ===================================================================================
# Wir fügen die offizielle Quelle für die Temurin OpenJDK-Builds hinzu.
RUN wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor -o /etc/apt/keyrings/adoptium.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/adoptium.gpg] https://packages.adoptium.net/artifactory/deb $(. /etc/os-release && echo "$VERSION_CODENAME") main" | tee /etc/apt/sources.list.d/adoptium.list

# Abschnitt 6: Installation der finalen Pakete (Docker CLI & Java 21)
# ===================================================================
RUN apt-get update
# Installiere nur den Docker-Client (CLI)
RUN apt-get install -y docker-ce-cli
# ...und installiere Java 21 (JDK - Java Development Kit)
RUN apt-get install -y temurin-21-jdk

# Abschnitt 7: Umgebungsvariablen und Standard-Versionen konfigurieren
# ====================================================================
# Setzt die JAVA_HOME Umgebungsvariable. Maven und andere Tools benötigen diese,
# um das richtige JDK zu finden.
ENV JAVA_HOME /usr/lib/jvm/temurin-21-jdk-$(dpkg --print-architecture)

# Das Basis-Image hat bereits eine Java-Version. Dieser Befehl sorgt dafür,
# dass unser neu installiertes Java 21 die Standard-Version auf dem System ist.
RUN update-alternatives --install /usr/bin/java java ${JAVA_HOME}/bin/java 1
RUN update-alternatives --set java ${JAVA_HOME}/bin/java

# Abschnitt 8: Zurück zum sicheren Standard-Benutzer wechseln
# ===========================================================
# Wichtiger Sicherheitsschritt am Ende aller Installationen.
USER jenkins
