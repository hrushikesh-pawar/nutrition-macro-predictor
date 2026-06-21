# Nutrition & Macro Predictor

A Python-based data analytics project that helps fitness enthusiasts, 
coaches, and nutritionists find the best foods for their goals — 
built on a combined dataset of 1,274 Indian and Western food items.

## Problem
Most nutrition tools are built for Western diets. Indian foods — dal, 
sabzi, roti, khichdi — are missing from most datasets. This project 
combines both.

## What This Project Does
- Cleans and merges real nutrition datasets (335 Western + 1,014 Indian foods)
- Calculates protein efficiency (protein per calorie) for every food
- Identifies top protein sources by category using GroupBy analysis
- Provides a food lookup function — search any food, get full macro breakdown
- Recommends top foods based on calorie limit and protein goals

## Key Findings
- Fish and Seafood dominates protein efficiency in Western foods
- Indian soups (Palak ka soup, Chicken sweet corn soup) outperform 
  Shrimp in protein-per-calorie ratio
- Vegetables average under 70 calories per serving — best category 
  for calorie-controlled diets

## Tech Stack
Python | Pandas | Matplotlib | Jupyter Notebook

## Dataset
- Western nutrition data: 335 foods (Kaggle)
- Indian food nutrition: 1,014 dishes (Kaggle — batthulavinay)
- Combined: 1,274 rows after cleaning

## Status
In progress — predictor logic built, ML component next.
