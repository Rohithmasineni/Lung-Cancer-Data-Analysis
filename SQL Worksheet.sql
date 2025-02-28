CREATE DATABASE lung_cancer_analysis;        # CREATED A DATABASE

USE lung_cancer_analysis;           # SELECTED DATABASE

CREATE TABLE lung_cancer_data (                    
    ID INT PRIMARY KEY,
    Country VARCHAR(255),
    Population_Size INT,
    Age INT,
    Gender VARCHAR(10),
    Smoker VARCHAR(3),
    Years_of_Smoking INT,
    Cigarettes_per_Day INT,
    Passive_Smoker VARCHAR(3),
    Family_History VARCHAR(3),
    Lung_Cancer_Diagnosis VARCHAR(3),
    Cancer_Stage VARCHAR(50),
    Survival_Years INT,
    Adenocarcinoma_Type VARCHAR(50),
    Air_Pollution_Exposure VARCHAR(10),
    Occupational_Exposure VARCHAR(3),
    Indoor_Pollution VARCHAR(3),
    Healthcare_Access VARCHAR(50),
    Early_Detection VARCHAR(3),
    Treatment_Type VARCHAR(50),
    Developed_or_Developing VARCHAR(50),
    Annual_Lung_Cancer_Deaths INT,
    Lung_Cancer_Prevalence_Rate FLOAT,
    Mortality_Rate FLOAT
);                                              # CREATE TABLE WITH ALL THE REQUIRED COLUMNS or WHICH MATCHES THE DATASET

SELECT * FROM lung_cancer_data;    

# IMPORTING THE DATA USING CMD PROMPT

-- C:\\Users\\rohit\\Downloads\\INNOMATICS\\Projectsss\\Lung Cancer Project Challenge\\lung_cancer_Dataset.csv

-- USE lung_cancer_analysis;

-- LOAD DATA LOCAL INFILE 'C:\\Users\\rohit\\Downloads\\INNOMATICS\\Projectsss\\Lung Cancer Project Challenge\\lung_cancer_Dataset.csv'
-- INTO TABLE lung_cancer_data
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n' IGNORE 1 rows;

# NOW THE DATA IS IMPORTED

SELECT * FROM lung_cancer_data;  # CHECKING IF THE DTA IS IMPORTED OR NOT

SELECT COUNT(*) FROM lung_cancer_data;   # MAKING SURE THAT ALL THE ROWS ARE IMPORTED

# Questions To Solve


-- 1. Retrieve all records for individuals diagnosed with lung cancer.
SELECT *
FROM lung_cancer_data
WHERE Lung_Cancer_Diagnosis = "Yes";

-- 2. Count the number of smokers and non-smokers.
SELECT Smoker, Count(Smoker) AS Count
FROM lung_cancer_data
GROUP BY Smoker;

-- 3. List all unique cancer stages present in the dataset.
SELECT DISTINCT(Cancer_Stage)
FROM lung_cancer_data;


-- 4. Retrieve the average number of cigarettes smoked per day by smokers.
SELECT AVG(Cigarettes_per_Day) AS Avg_Per_Day
FROM lung_cancer_data
WHERE Smoker = 'Yes';

-- 5. Count the number of people exposed to high air pollution.
SELECT COUNT(Id)
FROM lung_cancer_data
WHERE Air_Pollution_Exposure = 'High';

-- 6. Find the top 5 countries with the highest lung cancer deaths.
SELECT DISTINCT(Country), 
	   Annual_Lung_Cancer_Deaths
FROM lung_cancer_data
ORDER BY Annual_Lung_Cancer_Deaths DESC
LIMIT 5;

-- 7. Count the number of people diagnosed with lung cancer by gender.
SELECT Gender,
	   COUNT(Id) AS Count_of_people_Diagnosed
FROM lung_cancer_data
WHERE Lung_Cancer_Diagnosis = 'Yes'
GROUP BY Gender;

-- 8. Retrieve records of individuals older than 60 who are diagnosed with lung cancer.
SELECT *
FROM lung_cancer_data
WHERE Age > 60 AND Lung_Cancer_Diagnosis = 'Yes';


-- 1. Find the percentage of smokers who developed lung cancer.

SELECT ROUND((Smokers_developed_cancer.Smokers_developed_cancer / Total_Smokers.Total_Smokers_Count)*100, 2) AS percentage_of_smokers_developed_cancer
FROM (SELECT COUNT(*) AS Total_Smokers_Count 
	  FROM lung_cancer_data WHERE Smoker = 'Yes') 
      AS Total_Smokers,
	 (SELECT COUNT(*) AS Smokers_developed_cancer 
      FROM lung_cancer_data 
      WHERE Smoker = 'Yes' AND Developed_or_Developing = 'Developed') 
      AS Smokers_developed_cancer;
      
-- 2. Calculate the average survival years based on cancer stages.

SELECT Cancer_Stage, 
       AVG(Survival_Years) AS average_survival_years
FROM lung_cancer_data 
GROUP BY Cancer_Stage;

-- 3. Count the number of lung cancer patients based on passive smoking.

SELECT Passive_Smoker,
	   COUNT(*) AS Count
FROM lung_cancer_data
GROUP BY Passive_Smoker;


-- 4. Find the country with the highest lung cancer prevalence rate.
SELECT Country,
	   Lung_Cancer_Prevalence_Rate
FROM lung_cancer_data
ORDER BY Lung_Cancer_Prevalence_Rate DESC
LIMIT 1;


-- 5. Identify the smoking years impact on lung cancer.
SELECT Cancer_Stage,
	   AVG(Years_of_Smoking) AS Avg_smoking_years
FROM lung_cancer_data
GROUP BY Cancer_Stage;


-- 6. Determine the mortality rate for patients with and without early detection.
SELECT Early_Detection,
	   AVG(Mortality_Rate) Avg_Mortality_Rate
FROM lung_cancer_data
GROUP BY Early_Detection;

-- If Avg_Mortality_Rate is lower for patients with early detection, it suggests that early detection improves survival rates.
-- If the difference is small or non-existent, other factors might be influencing mortality.


-- 7. Group the lung cancer prevalence rate by developed vs. developing countries.

SELECT Developed_or_Developing,
	   AVG(Lung_Cancer_Prevalence_Rate) AS Avg_Lung_Cancer_Prevalence_Rate
FROM lung_cancer_data
GROUP BY Developed_or_Developing;

-- This will show if the lung cancer prevalence rate is different between patients who have developed lung cancer vs. those who are still developing it.

-- 1. Identify the correlation between lung cancer prevalence and air pollution levels.

SELECT Air_Pollution_Exposure,
	   round(avg(Lung_Cancer_Prevalence_Rate),2) AS Avg_Prevalence
FROM lung_cancer_data
GROUP BY Air_Pollution_Exposure
ORDER BY Avg_Prevalence DESC;


-- 2. Find the average age of lung cancer patients for each country.

SELECT Country,
	   ROUND(AVG(Age),2) AS Avg_Age
FROM lung_cancer_data
WHERE Lung_Cancer_Diagnosis = "Yes"
GROUP BY Country
ORDER BY Avg_Age DESC;

-- 3. Calculate the risk factor of lung cancer by smoker status, passive smoking, and family history.
SELECT Smoker AS Smoker_Status, 
	   Passive_Smoker AS Passive_Smoking,
	   Family_History AS Family_History,
       Count(*) AS Total_Population,
       SUM(CASE WHEN Developed_or_Developing = 'Developed' OR Lung_Cancer_Diagnosis = 'Yes' THEN 1 ELSE 0 END) AS Disease_Developed,
       (SUM(CASE WHEN Developed_or_Developing = 'Developed' OR Lung_Cancer_Diagnosis = 'Yes' THEN 1 ELSE 0 END) 
       / COUNT(*)) * 100 AS Risk_Factor
FROM lung_cancer_data
GROUP BY Smoker, Passive_Smoker, Family_History;

SELECT COUNT(*) FROM lung_cancer_data;


-- 4. Rank countries based on their mortality rate.
SELECT RANK() OVER (ORDER BY AVG(Mortality_Rate) DESC) AS mortality_rate,
	   Country,
	   AVG(Mortality_Rate) AS avg_mortality_rate
FROM lung_cancer_data
WHERE Lung_Cancer_Diagnosis = "Yes"
GROUP BY Country;

SELECT * FROM lung_cancer_data;


-- 5. Determine if treatment type has a significant impact on survival years.

SELECT Treatment_Type,
	   AVG(Survival_Years) AS Avg_Survival_Years 
FROM lung_cancer_data
GROUP BY Treatment_Type;


-- 6. Compare lung cancer prevalence in men vs. women across countries.

SELECT Country,
	   Gender,
       ROUND(AVG(Lung_Cancer_Prevalence_Rate),2) AS avg_lung_cancer_prevalence_rate
FROM lung_cancer_data
GROUP BY Country, Gender
ORDER BY Country;


-- 7. Find how occupational exposure, smoking, and air pollution collectively impact lung cancer rates.

SELECT Occupational_Exposure,
	   Smoker,
       Air_Pollution_Exposure,
       (SUM(CASE WHEN Lung_Cancer_Diagnosis = 'Yes' THEN 1 ELSE 0 END)/COUNT(*))*100 AS lung_cancer_rates
FROM lung_cancer_data
GROUP BY Occupational_Exposure, Smoker, Air_Pollution_Exposure
ORDER BY lung_cancer_rates DESC;


-- 8. Analyze the impact of early detection on survival years.

SELECT Early_Detection,
	   AVG(Survival_Years) AS avg_survival_years
FROM lung_cancer_data
WHERE Lung_Cancer_Diagnosis = "Yes"
GROUP BY Early_Detection
ORDER BY avg_survival_years DESC;