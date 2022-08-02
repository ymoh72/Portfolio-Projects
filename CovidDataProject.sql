SELECT * FROM
CovidProject..CovidDeaths$
WHERE continent IS NOT NULL
ORDER BY 3,4;

--SELECT * FROM
--CovidProject..CovidVaccinations$
--ORDER BY 3,4;

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM CovidProject..CovidDeaths$
ORDER BY 1,2

--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract COVID in each country
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidProject..CovidDeaths$
WHERE location LIKE '%states%'
ORDER BY 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population has contracted COVID
SELECT Location, date, total_cases, population, (total_cases/population)*100 AS DeathPercentage
FROM CovidProject..CovidDeaths$
WHERE location LIKE '%states%'
ORDER BY 1,2

--Looking at countries with highest infection rate compared to total population

SELECT Location, population, MAX(total_cases) AS HighestInfectionCount, MAX(total_deaths/total_cases)*100 AS PercentOfInfectedPopulation
FROM CovidProject..CovidDeaths$
GROUP BY location, population
ORDER BY PercentOfInfectedPopulation DESC

--Looking at countries with highest death count per population

SELECT Location, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM CovidProject..CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

--GROUPING BY CONTINENT
--Showing continents with highest death count

SELECT continent, MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM CovidProject..CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC


--GLOBAL NUMBERS

SELECT date, SUM(new_cases) AS total_cases, SUM(cast(new_deaths AS int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 AS DeathPercentage
FROM CovidProject..CovidDeaths$
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2


--Looking at Total Population vs Vaccinations (using CTE)

WITH PopsVac(continent, location, date, population, RollingCountVaccinated,new_vaccinations)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,	SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
	dea.date) AS RollingCountVaccinated
	--, (RollingPeopleVaccinated/population)*100
FROM CovidProject..CovidDeaths$ dea
JOIN CovidProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL
	--ORDER BY 2,3
	)

	SELECT *, (RollingCountVaccinated/population)*100
	FROM PopsVac


--TEMP TABLE

DROP TABLE IF exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingCountVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,	SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
	dea.date) AS RollingCountVaccinated
	--, (RollingPeopleVaccinated/population)*100
FROM CovidProject..CovidDeaths$ dea
JOIN CovidProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL

	SELECT *, (RollingCountVaccinated/population)*100
	FROM #PercentPopulationVaccinated



--Creating view to store data for later visualizations

CREATE VIEW 
PercentPopulationsVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,	SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,
	dea.date) AS RollingCountVaccinated
	--, (RollingPeopleVaccinated/population)*100
FROM CovidProject..CovidDeaths$ dea
JOIN CovidProject..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL

SELECT *
FROM PercentPopulationsVaccinated