# /etc/R/lab_utils.R

#' Connect to AffCom Research Servers
connect_lab_drives <- function(username = NULL) {
  
    # --- SERVER CONFIGURATION ---
    mounts <- list(
        list(
            remote = "//resfs.home.ku.edu/groups_hipaa/lsi/jgirard/general/datasets", 
            local = "/mnt/datasets",
            flags = "ro,vers=3.0,sec=ntlmssp" 
        ),
        list(
            remote = "//resfs.home.ku.edu/groups_hipaa/lsi/jgirard/general/projects", 
            local = "/mnt/projects",
            flags = "rw,vers=3.0,sec=ntlmssp,file_mode=0777,dir_mode=0777"
        )
    )
    # ----------------------------

    # 1. Check if already connected
    if (length(list.files(mounts[[1]]$local)) > 0) {
        message("✅ Lab drives appear to be already connected.")
        return(invisible(TRUE))
    }

    # 2. Check Network Connectivity
    message("Checking KU network connectivity...")
    test_con <- try(
        socketConnection("resfs.home.ku.edu", port = 445, timeout = 2, open = "r"), 
        silent = TRUE
    )
    
    if (!inherits(test_con, "connection")) {
        message("\n❌ ERROR: Cannot reach the KU research server.")
        message("💡 Hint: Are you connected to the KU Anywhere VPN or the campus network?\n")
        return(invisible(FALSE))
    }
    close(test_con)

    # 3. Get Credentials
    message("--- AffCom Lab Server Login ---")
    if (is.null(username)) {
        username <- rstudioapi::showPrompt("Login", "Enter KU Username: ")
    }
    password <- rstudioapi::askForPassword("Enter KU Password: ")

    # 4. Mount Loop with specific error checking
    success <- TRUE
    for (m in mounts) {
        # Create a temporary file to capture the mount command's error output
        err_file <- tempfile()
        
        # Redirect stderr (2>) to the temporary file
        cmd <- sprintf(
            "sudo mount -t cifs '%s' '%s' -o username='%s',password='%s',%s 2>%s",
            m$remote, m$local, username, password, m$flags, err_file
        )
    
        exit_code <- system(cmd)
        err_msg <- readLines(err_file, warn = FALSE)
        unlink(err_file)
    
        if (exit_code == 0) {
            perm_label <- ifelse(grepl("ro,", m$flags), "(Read-Only)", "(Read-Write)")
            message(sprintf("✅ Mounted: %s %s", m$local, perm_label))
        } else {
            # Specifically check for "Permission denied" in the captured error
            if (any(grepl("Permission denied", err_msg, ignore.case = TRUE))) {
                message(sprintf("❌ Failed to mount %s: Incorrect username or password.", m$local))
            } else {
                message(sprintf("❌ Failed to mount %s: %s", m$local, paste(err_msg, collapse = " ")))
            }
            success <- FALSE
        }
    }

    if (success) {
        message("\n🚀 All drives connected successfully!")
    } else {
        warning("\n⚠️ Some drives failed to connect. Double-check your credentials.")
    }
}

# Display welcome message in interactive sessions
if (interactive()) {
    cat("\n------------------------------------------------------------\n")
    message("Welcome to the AffCom Lab Bayesian Environment!")
    message("To access the research servers, please run:")
    message("connect_lab_drives()")
    cat("------------------------------------------------------------\n\n")
}