# Design Document

## Project Name

Linux Network Administration

## Purpose

The purpose of this project is to create a reusable Bash script that performs a structured audit of a Linux system's network configuration and current network state.

The script will collect information using standard Linux utilities and write the results to a timestamped text report.

## Design Goals

The script should be:

- Readable
- Modular
- Professionally commented
- Safe to run
- Non-destructive
- Useful for troubleshooting
- Suitable for portfolio demonstration
- Compatible with Rocky Linux

## Planned Input

The script will not initially require user input.

It will inspect the local system on which it is executed.

## Planned Output

Reports will be stored under:

```text
reports/