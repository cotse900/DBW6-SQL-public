--cleaning scripts:
--gather sources listed below
--with python, run "python script.py file.csv" to clean and extract data
--load output files into SQL database DBW624, first onto a staging table, then to the eventual definition table


USE DBW624;
--Baby_names reference table
--https://data.ontario.ca/dataset/ontario-top-baby-names-male
--https://data.ontario.ca/dataset/ontario-top-baby-names-female
--one null value is found in the male name list
--I added extra code in clean_baby_names_csv.py to remove it since there is no way to establish it as a legit value
--staging

IF OBJECT_ID('csv_baby_names', 'U') IS NOT NULL
    DROP TABLE csv_baby_names;

IF OBJECT_ID('Baby_names', 'U') IS NOT NULL
    DROP TABLE Baby_names;

CREATE TABLE csv_baby_names (
    BabyYear INT,
    BabyName VARCHAR(255),
    Frequency INT,
	BabyGender VARCHAR(20)
);
--female names
BULK INSERT csv_baby_names
FROM 'C:\Documents\dbw624_data\ontario_top_baby_names_female_1917-2019_en_fr_append.csv'--86388 names
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

--male names
BULK INSERT csv_baby_names
FROM 'C:\Documents\dbw624_data\ontario_top_baby_names_male_1917-2019_en_fr_append.csv'--78302 names
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

--transfer data to Baby_names
CREATE TABLE Baby_names (
    BabyNameID INT IDENTITY(1,1),
    BabyYear INT not null check (BabyYear >= 1900),
    BabyName VARCHAR(255) not null,
    Frequency INT not null check (Frequency > 0),
    BabyGender VARCHAR(20) not null,
	PRIMARY KEY (BabyNameID)
);

-- Insert data into Baby_names
INSERT INTO Baby_names (BabyYear, BabyName, Frequency, BabyGender)
SELECT BabyYear, BabyName, Frequency, BabyGender
FROM csv_baby_names
--WHERE Frequency >= 200 AND BabyYear between 1980 and 2019; --for more modern names

SELECT TOP 20 * FROM Baby_names;

SELECT COUNT(*) FROM Baby_names;

--delete from Baby_names;
--drop table Baby_names;

--Population reference table
--https://www12.statcan.gc.ca/census-recensement/2016/dp-pd/hlt-fst/pd-pl/Table.cfm?Lang=Eng&T=701&SR=1&S=3&O=D&RPP=9999&PR=35&CMA=0#tPopDwell
IF OBJECT_ID('csv_population', 'U') IS NOT NULL
    DROP TABLE csv_population;

IF OBJECT_ID('Population', 'U') IS NOT NULL
    DROP TABLE Population;

CREATE TABLE csv_population (
    PopID INT,
    CityRegion VARCHAR(60),
    Population INT,
    Province VARCHAR(30),
    PopYear INT
);

BULK INSERT csv_population
FROM 'C:\Documents\dbw624_data\T70120231017023713_population_append.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);


CREATE TABLE Population (
  PopID INT, --directly from csv_population
  CityRegion VARCHAR(50) not null,
  Population INT not null check (Population > 0),
  Province VARCHAR(30) not null,
  PopYear INT not null check (PopYear > 2000),
  PRIMARY KEY (PopID)
);

INSERT INTO Population (PopID, CityRegion, Population, Province, PopYear)
SELECT PopID, CityRegion, Population, Province, PopYear
FROM csv_population;

SELECT TOP 20 * FROM Population;

SELECT COUNT(*) FROM Population;


--Life expectancy reference table
--https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=1310006301
--I picked at birth for figures like "age 80/80 years" because "at 65" means "how many years left to live" which is just 20 years

IF OBJECT_ID('csv_lifeexp', 'U') IS NOT NULL
    DROP TABLE csv_lifeexp;

IF OBJECT_ID('Life_expectancy', 'U') IS NOT NULL
    DROP TABLE Life_expectancy;

CREATE TABLE csv_lifeexp (
    CityRegion VARCHAR(100),
	BirthYear INT, -- the data were from 2018, so age 0 = birth year 2018
	Gender VARCHAR(20),
	LifeExpectancy Decimal(10, 2)
);

BULK INSERT csv_lifeexp
FROM 'C:\Documents\dbw624_data\1310006301-eng_ON_lifeexp_female_age0_append.csv'--female
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

BULK INSERT csv_lifeexp
FROM 'C:\Documents\dbw624_data\1310006301-eng_ON_lifeexp_male_age0_append.csv'--male
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

CREATE TABLE Life_expectancy (
  LifeExpID INT IDENTITY(1,1),
  CityRegion VARCHAR(100) not null,
  BirthYear INT not null check (BirthYear > 2000),
  Gender VARCHAR(20) not null,
  LifeExpectancy Decimal(10, 2) not null check (LifeExpectancy > 0.00),
  PRIMARY KEY (LifeExpID)
);

INSERT INTO [Life_expectancy] (CityRegion, BirthYear, Gender, LifeExpectancy)
SELECT CityRegion, BirthYear, Gender, LifeExpectancy
FROM csv_lifeexp;

SELECT TOP 20 * FROM Life_expectancy;

SELECT COUNT(*) FROM Life_expectancy;