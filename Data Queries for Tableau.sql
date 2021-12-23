/*
Queries used for Tableau Project
*/

-- 1. 

Select SUM(new_cases) as Total_Cases, SUM(Convert(bigint, new_deaths)) as Total_Deaths
, SUM(Convert(bigint, new_deaths))/SUM(new_cases)*100 as Death_Percentage
From [Portofolio Project 1]..CovidDeath
--Where location = 'Indonesia'
Where continent is not null
--Group by date
Order by 1, 2


-- 2. 

Select location, SUM(Convert(bigint, new_deaths)) as Total_Death_Count
From [Portofolio Project 1]..CovidDeath
--Where location = 'Indonesia'
Where continent is null
and location not in ('World', 'European Union', 'International', 'Upper middle income', 'High income', 'Lower middle income', 'Low income')
Group by location
Order by Total_Death_Count desc


-- 3.

Select Location, Population, MAX(total_cases) as Highest_Infection_Count, MAX((total_cases/population))*100 as Percent_Population_Infected
From [Portofolio Project 1]..CovidDeath
--Where location = 'Indonesia'
Group by Location, Population
Order by Percent_Population_Infected desc


-- 4.

Select Location, Population, date, MAX(total_cases) as Highest_Infection_Count, MAX((total_cases/population))*100 as Percent_Population_Infected
From [Portofolio Project 1]..CovidDeath
--Where location = 'Indonesia'
Group by Location, Population, date
Order by Percent_Population_Infected desc