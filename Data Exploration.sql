Select *
From CovidDeath
Order by (location), (date)

Select *
From CovidVaccination
Order by (location), (date)

Select location, date, total_cases, new_cases, total_deaths, population
From CovidDeath
Order by location, date

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeath
Where location = 'Indonesia'
Order by location, date

Select location, date, total_cases, population, (total_cases/population)*100 as PopulationInfectedPercentage
From CovidDeath
Where location = 'Indonesia'
Order by location, date

Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PopulationInfectedPercentage
From CovidDeath
Where location = 'Indonesia'
Group by location, population
Order by PopulationInfectedPercentage desc

Select location, Max(cast(total_deaths as int)) as HighestTotalDeaths
From CovidDeath
Where continent is not null
Group by location
Order by HighestTotalDeaths desc

Select continent, Max(cast(total_deaths as int)) as HighestTotalDeaths
From CovidDeath
Where continent is not null
Group by continent
Order by HighestTotalDeaths desc

Select Sum(new_cases) as TotalCases, Sum(cast(new_deaths as int)) as TotalDeaths, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as DeathPercentage
From CovidDeath
Where continent is not null
Group by date
Order by 1

Select D.continent, D.location, D.date, D.population, V.new_vaccinations
, Sum(Convert(bigint, V.new_vaccinations)) over (Partition by D.location Order by D.location, D.date) as RollingPeopleVaccinated
From CovidDeath as D
Join CovidVaccination as V
	On D.location = V.location
	and D.date = V.date
Where D.continent is not null and d.location = 'Indonesia'
Order by 2, 3

With PopVsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select D.continent, D.location, D.date, D.population, V.new_vaccinations
, Sum(Convert(bigint, V.new_vaccinations)) over (Partition by D.location Order by D.location, D.date) as RollingPeopleVaccinated
From CovidDeath as D
Join CovidVaccination as V
	On D.location = V.location
	and D.date = V.date
Where D.continent is not null and d.location = 'Indonesia'
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopVsVac

Drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric)

Insert into #PercentPopulationVaccinated
Select D.continent, D.location, D.date, D.population, V.new_vaccinations
, Sum(Convert(bigint, V.new_vaccinations)) over (Partition by D.location Order by D.location, D.date) as RollingPeopleVaccinated
From CovidDeath as D
Join CovidVaccination as V
	On D.location = V.location
	and D.date = V.date
Where D.continent is not null

Select *, (RollingPeopleVaccinated/Population)*100 as PeopleVaccinatedPercent
From #PercentPopulationVaccinated

Create view PercentPopulationVaccinated as
Select D.continent, D.location, D.date, D.population, V.new_vaccinations
, Sum(Convert(bigint, V.new_vaccinations)) over (Partition by D.location Order by D.location, D.date) as RollingPeopleVaccinated
From CovidDeath as D
Join CovidVaccination as V
	On D.location = V.location
	and D.date = V.date
Where D.continent is not null

Select *
From PercentPopulationVaccinated