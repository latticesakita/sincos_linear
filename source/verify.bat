@echo off


call "%OneDrive%\Documents\venv-3.12\Scripts\Activate.bat"

perl verify_linear.pl ../tb/sim_full_output.csv

