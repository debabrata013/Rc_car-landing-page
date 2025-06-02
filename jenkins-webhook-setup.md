# Setting Up GitHub Webhook for Jenkins

This guide will help you set up a webhook in GitHub to automatically trigger your Jenkins pipeline when you push code.

## Step 1: Install Required Jenkins Plugins

1. Log in to your Jenkins server
2. Go to "Manage Jenkins" > "Manage Plugins"
3. Go to the "Available" tab
4. Search for and install these plugins if they're not already installed:
   - GitHub Integration
   - GitHub plugin
   - Git plugin
5. Restart Jenkins after installation

## Step 2: Configure Jenkins for Webhooks

1. Go to "Manage Jenkins" > "Configure System"
2. Scroll down to the "GitHub" section
3. Click "Add GitHub Server"
4. Give it a name (e.g., "GitHub")
5. For API URL, use `https://api.github.com`
6. Add GitHub credentials if you want to use authenticated API requests
7. Test the connection
8. Save the configuration

## Step 3: Configure Your Jenkins Pipeline

1. Go to your pipeline job
2. Click "Configure"
3. In the "Build Triggers" section, check "GitHub hook trigger for GITScm polling"
4. Save the configuration

## Step 4: Set Up the Webhook in GitHub

1. Go to your GitHub repository
2. Click "Settings"
3. Click "Webhooks" in the left sidebar
4. Click "Add webhook"
5. For the Payload URL, enter:
   ```
   http://YOUR_JENKINS_URL/github-webhook/
   ```
   Replace `YOUR_JENKINS_URL` with your actual Jenkins URL
6. Set Content type to "application/json"
7. For "Which events would you like to trigger this webhook?", select "Just the push event"
8. Check "Active"
9. Click "Add webhook"

## Step 5: Test the Webhook

1. Make a small change to your repository
2. Commit and push the change
3. Go to your Jenkins pipeline
4. Verify that a new build was automatically triggered

## Troubleshooting

If the webhook isn't working:

1. Check that your Jenkins URL is publicly accessible from GitHub
2. Verify the webhook in GitHub (look for green checkmarks in the webhook's recent deliveries)
3. Check Jenkins logs for any errors
4. Make sure the GitHub plugin is properly configured
5. Ensure your Jenkins user has permission to receive webhooks
