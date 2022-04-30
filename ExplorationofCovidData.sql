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


select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location ORDER BY dea.location,
dea.Date) as RollingPeopleVaccinated
FROM [Portfolio Project]..['covid-Deaths$'] dea
Join [Portfolio Project]..['covid-vaccinations$'] vac
ON dea.location = vac.location
AND dea.date = vac.date
where dea.continent is not null
Order by 2,3




--Use CTE
With PopvsVac (Continent, Location, Date, Population,New_vaccination, RollingPeopleVaccinated)
as
(
SELECT dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (partition by dea.location ORDER BY dea.location,
dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
FROM [Portfolio Project]..['covid-Deaths$'] dea
Join [Portfolio Project]..['covid-vaccinations$'] vac
ON dea.location = vac.location
AND dea.date = vac.date
where dea.continent is not null
--Order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM [Portfolio Project]..['covid-Deaths$'] dea
Join [Portfolio Project]..['covid-vaccinations$'] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM [Portfolio Project]..['covid-Deaths$'] dea
Join [Portfolio Project]..['covid-vaccinations$'] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

select * 
FROM PercentPopulationVaccinated
