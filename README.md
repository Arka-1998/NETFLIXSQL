# Netflix Movies and TV Shows Data Analysis using SQL

## Overview

This project entails doing a thorough study of Netflix's movie and TV program data using SQL.  The purpose is to extract important insights and answer various business issues using the information.  The README below contains a full summary of the project's aims, business challenges, solutions, findings, and conclusions.

## Objective

- Analyse the distribution of content kinds (movies against TV series).
- Determine the most frequent ratings for films and television shows.
- List and analyse material by release year, country, and duration.
- Explore and categorise information using particular parameters and keywords.

## Dataset

- link: [NETFLIX DATA](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

 DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
	show_id	VARCHAR(5),
	type    VARCHAR(10),
	title	VARCHAR(250),
	director VARCHAR(550),
	casts	VARCHAR(1050),
	country	VARCHAR(550),
	date_added	VARCHAR(55),
	release_year	INT,
	rating	VARCHAR(15),
	duration	VARCHAR(15),
	listed_in	VARCHAR(250),
	description VARCHAR(550)
