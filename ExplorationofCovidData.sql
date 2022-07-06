Select *
FROM [Portfolio Project]..['covid-Deaths$']
where continent is not null
order by 3,4


--Select *
--FROM [Portfolio Project]..['covid-vaccinations$']
--order by 3,4

Select location,date,total_cases,new_cases,total_deaths,population
FROM [Portfolio Project]..['covid-Deaths$']
order by 1,2


--Looking at total Cases Vs Total Deaths
--Shows liklihood of dying in your Country if contracting Covid

Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM [Portfolio Project]..['covid-Deaths$']
order by 1,2

Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM [Portfolio Project]..['covid-Deaths$']
Where location LIKE '%states%'
and continent is not null
order by 1,2

Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM [Portfolio Project]..['covid-Deaths$']
Where location Like '%Ireland%'
order by 1,2

--Looking at Total Cases Versus Population
--Shows what percentage of population has gotten Covid From US and Ireland

Select location,date,population,total_cases, (total_cases/population)*100 as PercentageofPopulationWithCovid
FROM [Portfolio Project]..['covid-Deaths$']
Where location LIKE '%states%'
order by 1,2

Select location,date,population,total_cases, (total_cases/population)*100  as PercentageofPopulationWithCovid
FROM [Portfolio Project]..['covid-Deaths$']
Where location Like '%Ireland%'
order by 1,2

--Looking at Countries with highest infection rate compared to population

Select location,population,max(total_cases) as HighestInfectionCount, max((total_cases/population))*100  as PercentageofPopulationWithCovid
FROM [Portfolio Project]..['covid-Deaths$']
Group By location, population
order by PercentageofPopulationWithCovid DESC




--Shwoing Countries with highest death count per population
Select location,Max(cast(total_deaths as int)) as TotalDeathCount
FROM [Portfolio Project]..['covid-Deaths$']
where continent is not null
Group By location
order by TotalDeathCount DESC


--Let's Break Things Down By Continent


--Showing Continents with the highest death count per population
Select continent,Max(cast(total_deaths as int)) as TotalDeathCount
FROM [Portfolio Project]..['covid-Deaths$']
where continent is not null
Group By continent
order by TotalDeathCount DESC



--Global Numbers

Select date,SUM(new_cases) as new_cases,SUM(cast(new_deaths as int)) as new_deaths,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage--total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM [Portfolio Project]..['covid-Deaths$']
Where continent is not  null
Group by date
order by 1,2


Select SUM(new_cases) as new_cases,SUM(cast(new_deaths as int)) as new_deaths,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage--total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM [Portfolio Project]..['covid-Deaths$']
Where continent is not  null
order by 1,2



--Looking at Total Population Versus Vaccination
--Joining Tables 

select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
FROM [Portfolio Project]..['covid-Deaths$'] dea
Join [Portfolio Project]..['covid-vaccinations$'] vac
ON dea.location = vac.location
AND dea.date = vac.date
where dea.continent is not null
Order by 1,2,3





--Queries used for Tableau Visualization

-- 1. 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2


-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


-- 3.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc

