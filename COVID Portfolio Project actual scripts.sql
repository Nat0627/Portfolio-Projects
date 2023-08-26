SELECT *
FROM ProjectPortfolio..CovidDeaths
WHERE continent is not null
ORDER BY 3, 4

--SELECT *
--FROM ProjectPortfolio..CovidVaccinations
--ORDER BY 3, 4

--Select the data we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM ProjectPortfolio..CovidDeaths
WHERE continent is not null
ORDER BY 1, 2

--Looking at Total Cases vs Total Deaths
-- Shows liklihood of dying if you contract COVID in your country
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathRatePercentage
FROM ProjectPortfolio..CovidDeaths
WHERE location like '%states%' and continent is not null
ORDER BY 1, 2


-- Looking at Total Cases vs Population 
-- Shows what % of population got Covid
SELECT location, date, population, total_cases, (total_cases/population)*100 as PopulationPercentInfected
FROM ProjectPortfolio..CovidDeaths
WHERE location like '%states%' and continent is not null
ORDER BY 1, 2


-- Looking at countries with highest infection rate compared to poulation
-- What % of your country's population has gotten infected?  

SELECT location,  population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
FROM ProjectPortfolio..CovidDeaths
--WHERE location like '%states%'
Group by location, population
ORDER BY PercentPopulationInfected desc


-- Showing countries with highest death count per population
SELECT location,  MAX(cast(total_deaths as int)) as TotalDeathCount
FROM ProjectPortfolio..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
Group by location
ORDER BY TotalDeathCount desc

-- LET'S BREAK THINGS OUT BY CONTINENT 

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM ProjectPortfolio..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
Group by continent
ORDER BY TotalDeathCount desc


-- Showing the continents with the highest death counts
-- Start looking at the data from the view point or perspective of how to visualize the data

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM ProjectPortfolio..CovidDeaths
--WHERE location like '%states%'
WHERE continent is not null
Group by continent
ORDER BY TotalDeathCount desc

-- GLOBAL #S
	-- Shows global death %

SELECT SUM(new_cases) as global_cases, SUM(cast(new_deaths as int)) as global_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as GlobalDeathPercentage
FROM ProjectPortfolio..CovidDeaths
--WHERE location like '%states%' 
WHERE continent is not null
--GROUP BY date
ORDER BY 1, 2

	-- Shows global death % by day

SELECT date, SUM(new_cases) as global_cases, SUM(cast(new_deaths as int)) as global_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as GlobalDeathPercentagebyDay
FROM ProjectPortfolio..CovidDeaths
--WHERE location like '%states%' 
WHERE continent is not null
GROUP BY date
ORDER BY 1, 2



-- Looking at Total Population vs Vaccinations (% of population vaccinated by location and date) 

-- USE CTE 
-- specify the columns we are going to input, and adds the column RollingPeopleVaccinated
-- the # of columns in the CTE must be the same as the # of columns being selected
-- order by clause cannot be in the query when using CTE; hence it is commented out
-- must run additonal querries that extend from the CTE with the new query being executed
With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
FROM ProjectPortfolio..CovidDeaths dea
JOIN ProjectPortfolio..CovidVaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2, 3
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac


-- Creating View to store data for later visualizations

CREATE VIEW
PercentagePopulationVaccinated as 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
FROM ProjectPortfolio..CovidDeaths dea
JOIN ProjectPortfolio..CovidVaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2, 3

SELECT *
FROM PercentagePopulationVaccinated