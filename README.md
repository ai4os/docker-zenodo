<div align="center">
  <img src="https://ai4eosc.eu/wp-content/uploads/sites/10/2022/09/horizontal-transparent.png" alt="logo" width="500"/>
</div>

This repository contains a Docker image designed to facilitate downloading datasets directly into a user's Nextcloud instance via a prestart task in a Nomad job.

# Usage
To use this Docker image, ensure you have the following variables set:

**DOI**: This environment variable should be set to the DOI (Digital Object Identifier) of the dataset you wish to download.

**FORCE_PULL**: This boolean environment variable, when set to true, triggers the removal of previous existing versions of the dataset and forces a fresh download.

# Zenodo container

[![Build image](https://github.com/ai4os/docker-zenodo/actions/workflows/main.yml/badge.svg)](https://github.com/ai4os/docker-zenodo/actions/workflows/main.yml)

The Docker image is available in the project's Harbor registry:

* `registry.services.ai4os.eu/ai4os/docker-zenodo:latest`


