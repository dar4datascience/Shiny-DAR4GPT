# Start with the base image
FROM python:3.10.13

# Add user and change working directory and user
RUN addgroup --system app && adduser --system --ingroup app app

# Update packages and install dependencies
USER root
RUN apt-get update && apt-get install -y \
    curl \
    apt-transport-https \
    ca-certificates \
    gnupg \
    --no-install-recommends

# Add Microsoft's GPG key and the VS Code repository
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | apt-key add -
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" | tee /etc/apt/sources.list.d/vscode.list

# Update packages and install VS Code
RUN apt-get update && apt-get install -y code

# Change the home directory and shell of the app user.
RUN usermod -d /home/app -s /bin/bash app

# Change the owner of the home directory to the app user.
RUN mkdir -p /home/app && chown -R app:app /home/app

# Switch to app user
USER app

# Copy your global configuration files
#COPY --chown=app:app .config/Code/User/settings.json /home/app/.vscode

# Switch to root user
USER root

# Copy requirements and install Python packages
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade -r requirements.txt

# Switch back to app user
USER app

# Set the working directory to the app user's home directory
WORKDIR /home/app

# Copy the app
COPY . .

# Run app on port 8080
# EXPOSE 8080
# CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]