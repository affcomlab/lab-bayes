# AffCom Lab: Bayesian Environment

This is the **AffCom Lab Edition** of the Bayesian analysis environment.

It is built on top of the public [jmgirard/rocker-bayes](https://github.com/jmgirard/rocker-bayes) image but adds a secure "Lab Layer" that allows you to connect directly to the AffCom **Datasets** and **Projects** network shares from inside your RStudio session.

### Features
- **Browser-Based Interface:** Runs a full RStudio Server instance accessible directly through your web browser.
- **Pre-Loaded Tools:** Comes with RStan, CmdStanR, brms, and other essential tools for Bayesian data analysis pre-installed.
- **Safety Rails:**
    + `/mnt/datasets`: Mounted **Read-Only** (You cannot accidentally delete raw data).
    + `/mnt/projects`: Mounted **Read-Write** (Save your scripts and model outputs here).

## Prerequisites

1.  **Docker Desktop:** [Download and install Docker Desktop](https://www.docker.com/products/docker-desktop/) on your local machine.
2.  **Network Access:** You must be connected to the campus network or VPN to access the lab drives.

## Setup & Launch

### 1. Download the Environment (One-Time Setup)
You do not need to install any special programming tools to download the lab environment.

1. Go to the GitHub repository Releases page: <https://github.com/affcomlab/lab-bayes/releases/latest>
2. Under the **Assets** section of the latest release, click on **Source code (zip)** to download the environment.
3. Extract (unzip) the downloaded folder to a permanent location on your computer, such as your Desktop or Documents folder.

### 2. Run the Environment & Access RStudio
Whenever you want to work in the lab environment, simply open your extracted `lab-bayes` folder and double-click the launcher script for your operating system. The script will start the server and automatically open RStudio in your web browser.

**For Windows:**
Double-click the `start-windows.bat` file. 
*(Note: If Windows Defender prompts you, click "More info" and then "Run anyway").*

**For Mac:**
macOS strictly protects you from running downloaded scripts on university laptops. The very first time you use this file, you must use the Terminal to tell your Mac it is safe.
1. Open the **Terminal** app (you can search for it using Spotlight / Command+Space).
2. Type the word `bash ` (please make sure to type a space after the word).
3. Drag and drop the `start-mac.command` file from your folder directly into the Terminal window.
4. Press **Enter**.

You only ever have to do this once! The script will automatically fix its own security permissions. The next time you want to work, you can just double-click the file normally.

*Note: The first time you run the start script, Docker will take a few minutes to download the necessary background files. Subsequent runs will be almost instant.*

## Usage Example

You can analyze datasets directly from the server and save your compiled models to your project folder.

```r
library(brms)
library(tidyverse)

# 1. Login (if you haven't already)
connect_lab_drives()

# 2. Load data from the DATASETS drive
df <- read_csv("/mnt/datasets/MyStudy/clean_data.csv")

# 3. Prepare data
df_summary <- df |>
  summarize(mean_score = mean(score), .by = subject_id)

# 4. Fit a Bayesian model
fit <- brm(
  mean_score ~ 1, 
  data = df_summary, 
  family = gaussian(),
  chains = 4, 
  cores = 4,
  backend = "cmdstanr"
  threads = threading(2)
)

# 5. Save results back to the PROJECTS drive
write_rds(fit, "/mnt/projects/MyStudy/Models/subject_intercept_model.rds")
```

## Best Practices: Using RStudio Projects

For the best experience, you should create or open an RStudio Project directly on the **Projects** drive. This ensures your working directory is correctly set and your environment is saved to the persistent lab storage.

### How to access /mnt/projects in the Project Wizard:
1. Go to **File > New Project...** (or Open Project).
2. Choose **New Directory** or **Existing Directory**.
3. In the directory selection window, the lab drives (/mnt) will not appear by default in the "Home" list.
4. Click the **Browse (...)** button.
5. In the file path bar or the "Go to folder" prompt, type `/mnt` and press Enter.
6. You can now select the `projects` folder to create or open your RStudio Project.

> **Note:** By working within a Project on `/mnt/projects`, all your paths can be relative (e.g., `read_csv("../datasets/study1.csv")`), making your code more portable.

## Shutdown

When you are finished working, it is good practice to shut down the server to save system resources. You can do this easily without the command line:
1. Open the **Docker Desktop** application.
2. Go to the **Containers** tab.
3. Find the `lab-bayes` container in the list and click the **Stop** (square) button.

## Troubleshooting

### "Connection failed" or "Host is down"
- **Check Credentials:** Did you type your password correctly?
- **Check NetID:** Use just your username (e.g., `jdoe`), not your full email.
- **Check Network:** Verify that you are connected to the campus network or VPN.

### "Permission Denied" when saving files
- **Wrong Folder:** Check where you are trying to save.
    + You **cannot** save to `/mnt/datasets` (Read-Only).
    + You **can** save to `/mnt/projects` (Read-Write).
