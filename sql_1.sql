use project_one;
select count(*) from covid_death;

select * from covid_death where continent <> "";
-- Countries with Highest Death Count per Population
Select location, MAX(total_deaths) as TotalDeathCount
From covid_death
Where continent <> "" 
Group by location
order by TotalDeathCount desc;
-- BREAKING THINGS DOWN BY CONTINENT
-- Showing contintents with the highest death count per population
Select la_date,continent, MAX(total_deaths) as TotalDeathCount
From covid_death
Where continent <> ""
Group by continent
order by TotalDeathCount desc;
-- Global numbers (across the world)
select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
From covid_death
-- Where location like '%states%'
where continent <> ""
-- Group By la_date
order by 2,3;

-- create view to store data for visualization :
Create View HighestDeathCount as
Select location, MAX(total_deaths) as TotalDeathCount
From covid_death
Where continent <> "" 
Group by location
order by TotalDeathCount desc;
select * from HighestDeathCount;
-- with covid_vac table :
--  Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

With PopvsVac (Continent, Location, la_date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.la_date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.la_date) as RollingPeopleVaccinated
-- , (RollingPeopleVaccinated/population)*100
From covid_deaths dea
Join covid_vaccination vac
	On dea.location = vac.location
	and dea.la_date = vac.ladate
where dea.continent <>""
order by 2,3
)
Select*, (RollingPeopleVaccinated/Population)*100
From PopvsVac