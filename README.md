# AffCom Lab: Bayesian Environment

This is the **AffCom Lab Edition** of the Bayesian analysis environment.

It is built on top of the public `jmgirard/rocker-bayes` image but adds a secure "Lab Layer" that allows you to connect directly to the AffCom **Datasets** and **Projects** network shares from inside your RStudio session.

### Features
- **Browser-Based Interface:** Runs a full RStudio Server instance accessible directly through your web browser.
- **Pre-Loaded Tools:** Comes with RStan, brms, and other essential tools for Bayesian data analysis pre-installed.
- **Safety Rails:**
    + `/mnt/datasets`: Mounted **Read-Only** (You cannot accidentally delete raw data).
    + `/mnt/projects`: Mounted **Read-Write** (Save your scripts and model outputs here).

## Prerequisites

1.  **Docker Desktop:** Installed and running on your local machine.
2.  **Network Access:** You must be connected to the campus network or VPN to access the lab drives.

## Setup & Launch

### 1. Download the Repository
Open a terminal (PowerShell or Terminal) and run:

```bash
git clone https://github.com/affcomlab/lab-bayes.git
cd lab-bayes
```

### 2. Start the Environment & Access RStudio
Instead of memorizing Docker commands, you can use the provided start scripts.

**For Windows:**
Run the `start_windows.bat` file from your terminal or double-click it in your file explorer.
```cmd
.\start_windows.bat
```

**For Mac/Linux:**
Run the `start_mac.sh` script from your terminal.
```bash
./start_mac.sh
```

*Note: The first time you run this, it will take a moment to download the environment. Subsequent runs will be very fast.*

Once the script finishes, it will provide a link. Open your preferred web browser and navigate to the provided link (**http://localhost:8787**).

### 3. Access RStudio
Open your preferred web browser and navigate to:
**http://localhost:8787**

### 4. Connect to Lab Drives
Once RStudio loads, run the connection function in the R console:

```r
connect_lab_drives()
```

You will be prompted for your **KU Online ID** and **Password** via a secure popup. 

If successful, you will see:
> ✅ Mounted: /mnt/datasets (Read-Only)
>
> ✅ Mounted: /mnt/projects (Read-Write)

## Usage Example

You can analyze datasets directly from the server and save your compiled models to your project folder.

```r
library(tidyverse)
library(brms)

# 1. Login (if you haven't already)
connect_lab_drives()

# 2. Load data from the DATASETS drive
df <- read_csv("/mnt/datasets/MyStudy/clean_data.csv")

# 3. Prepare data
df_summary <- 
    df |>
    summarize(
        mean_score = mean(score), 
        .by = subject_id
    )

# 4. Fit a Bayesian model
fit <- brm(
    mean_score ~ 1, 
    data = df_summary, 
    family = gaussian(),
    chains = 4, 
    cores = 4,
    backend = "cmdstanr",
    threads = threading(2)
)

# 5. Save results back to the PROJECTS drive
write_rds(fit, "/mnt/projects/MyStudy/Models/subject_intercept_model.rds")
```

## Shutdown

When you are finished working, return to your terminal inside the `lab-bayes` folder and stop the server container:

```bash
docker compose down
```

## Troubleshooting

### "Connection failed" or "Host is down"
- **Check Credentials:** Did you type your password correctly?
- **Check NetID:** Use just your username (e.g., `jdoe`), not your full email.
- **Check Network:** Verify that you are connected to the campus network or VPN.

### "Permission Denied" when saving files
- **Wrong Folder:** Check where you are trying to save.
    + You **cannot** save to `/mnt/datasets` (Read-Only).
    + You **can** save to `/mnt/projects` (Read-Write).
