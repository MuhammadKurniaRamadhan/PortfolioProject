/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

Select *
From [Portofolio Project 1]..CovidDeath
Where continent is not null 
Order by 3, 4


-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From [Portofolio Project 1]..CovidDeath
Where continent is not null 
Order by 1, 2


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
From [Portofolio Project 1]..CovidDeath
Where location = 'Indonesia' and continent is not null 
Order by 1, 2


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases, (total_cases/population)*100 as Percent_Population_Infected
From [Portofolio Project 1]..CovidDeath
--Where location = 'Indonesia'
Order by 1, 2


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as Highest_Infection_Count, Max((total_cases/population))*100 as Percent_Population_Infected
From [Portofolio Project 1]..CovidDeath
--Where location = 'Indonesia'
Group by Location, Population
Order by Percent_Population_Infected desc


-- Countries with Highest Death Count per Population

Select Location, MAX(Convert(bigint, Total_deaths)) as Total_Death_Count
From [Portofolio Project 1]..CovidDeath
--Where location = 'Indonesia'
Where continent is not null 
Group by Location
Order by Total_Death_Count desc


-- BREAKING THINGS DOWN BY CONTINENT
-- Showing contintents with the highest death count per population

Select continent, MAX(Convert(bigint, Total_deaths)) as Total_Death_Count
From [Portofolio Project 1]..CovidDeath
--Where location = 'Indonesia'
Where continent is not null 
Group by continent
Order by Total_Death_Count desc


-- GLOBAL NUMBERS

Select SUM(new_cases) as Total_Cases, SUM(Convert(bigint, new_deaths)) as Total_Deaths
, SUM(Convert(bigint, new_deaths))/SUM(new_cases)*100 as Death_Percentage
From [Portofolio Project 1]..CovidDeath
--Where location = 'Indonesia'
Where continent is not null 
--Group by date
Order by 1, 2


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as Rolling_People_Vaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portofolio Project 1]..CovidDeath dea
Join [Portofolio Project 1]..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null 
Order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopVsVac (Continent, Location, Date, Population, New_Vaccinations, Rolling_People_Vaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as Rolling_People_Vaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portofolio Project 1]..CovidDeath dea
Join [Portofolio Project 1]..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3
)
Select *, (Rolling_People_Vaccinated/Population)*100
From PopVsVac


-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rolling_People_Vaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as Rolling_People_Vaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portofolio Project 1]..CovidDeath dea
Join [Portofolio Project 1]..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
--Where dea.continent is not null
--Order by 2,3
Select *, (Rolling_People_Vaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as Rolling_People_Vaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portofolio Project 1]..CovidDeath dea
Join [Portofolio Project 1]..CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
Select *
From PercentPopulationVaccinated