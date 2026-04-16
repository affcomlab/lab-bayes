FROM jmgirard/rocker-bayes:latest

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    cifs-utils

# Create mount points
RUN mkdir -p /mnt/datasets
RUN mkdir -p /mnt/projects

# Copy the utility script to a non-library location
COPY lab_utils.R /etc/R/lab_utils.R

# Update the Rprofile.site to source from the new location
RUN R_HOME=$(R RHOME) && \
    echo "source('/etc/R/lab_utils.R')" >> ${R_HOME}/etc/Rprofile.site
