--Select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

Select * 
from PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4

--Select the data you will be using

Select Location, date, total_cases, new_cases, total_deaths, population 
from PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2

--Loking at Total Cases vs Total Deaths
-- shows liklihood of dying if you contract covid in your country 

Select Location, date, total_cases,total_deaths, CONVERT(DECIMAL(18, 2), (CONVERT(DECIMAL(18, 2), total_deaths) / CONVERT(DECIMAL(18, 2), total_cases)))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
Where location like '%nigeria%'
and continent is not null
order by 1,2

--Lookig at the Total Cases vs Population
--Shows what percentage of population got covid

Select Location, population, MAX(total_cases) as HighestInfectionCount, Max(CONVERT(DECIMAL(18, 2), total_cases) / CONVERT(DECIMAL(18, 2), population))*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--Where location like '%nigeria%'
Where continent is not null
Group by location, population
order by PercentPopulationInfected desc

--Showing Countries with Highest Death Count per Population

Select Location, Max(CONVERT(DECIMAL(18), total_deaths)) as TotalDeathCount --(---you use tge regular convertion)
from PortfolioProject..CovidDeaths
--Where location like '%nigeria%'
Where continent is not null
Group by location
order by TotalDeathCount desc

--or you can use casting it to int 

Select Location, Max(CAST (total_deaths as int)) as TotalDeathCount --(---you use cast)
from PortfolioProject..CovidDeaths
--Where location like '%nigeria%'
Where continent is not null
Group by location
order by TotalDeathCount desc

--LET'S BREAK THINGS DOWN BY CONTINENT

Select location, Max(CAST (total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--Where location like '%nigeria%'
Where continent is null
Group by location
order by TotalDeathCount desc

--Lets break things down by Continent
--Showing Continent with the highest death count per Population

Select continent, Max(CAST (total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
--Where continent like '%Africa%'
Where continent is not null
Group by continent
order by TotalDeathCount desc

--Global Numbers

Select date, SUM(new_cases) as SumOFNewCases, SUM(new_deaths), SUM(Convert(Decimal(18,2), New_deaths)) / (Convert(Decimal(18,2), New_Cases)) *100 as DeathPercentage
from PortfolioProject..CovidDeaths
--Where location like '%nigeria%'
Where continent is not null
group by date
order by 1,2

--Looking at Total Population vs Vaccinnations  

Select *
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date


Select dea.continent, dea.location ,dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(decimal(18,2), new_vaccinations)) OVER (PARTITION BY dea.location) as partioning
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.location like '%Albania%'
and dea.continent is not null
order by 2,3

Select dea.continent, dea.location ,dea.date, dea.population, vac.new_vaccinations,
SUM(Convert(decimal(18,2), new_vaccinations)) OVER (PARTITION BY dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
Where dea.location like '%Albania%'
and dea.continent is not null
order by 2,3




