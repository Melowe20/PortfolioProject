--Select *
--From [Portfolio Project]..covid_deaths
--Where continent is not null
--Order By 3,4

--Select *
--From [Portfolio Project]..covid_vacinations
--Where continent is not null
--Order By 3,4


----Select data to use
--Select Location, date, total_cases, new_cases, total_deaths, population
--From [Portfolio Project]..covid_deaths
--Where continent is not null
--Order By 1,2


----Total Cases vs Total Deaths
--Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
--From [Portfolio Project]..covid_deaths
--Where continent is not null
--Order By 1,2


--Total Cases vs Population
--Select Location, date, population, total_cases, (total_cases/population)*100 as Percent_Infection
--From [Portfolio Project]..covid_deaths
--Where location = 'United States'
--and continent is not null
--Order By 1,2


----Countries with Highest Infection Rates compared to Population
--Select Location, population, MAX(total_cases) as Highest_Infection_Count, MAX((total_cases/population))*100 as Percent_Infection
--From [Portfolio Project]..covid_deaths
--Where continent is not null
--Group By location, population
--Order By Percent_Infection desc


----Countries with Highest Death Count compared to Population
--Select Location, MAX(cast(total_deaths as int)) as Total_Death_Count, MAX((total_deaths/population))*100 as Population_Death_Percent
--From [Portfolio Project]..covid_deaths
--Where continent is not null
--Group By location, population
--Order By Total_Death_Count desc


----Continental Breakdown
----Death Breakdown by Continent
--Select location, MAX(cast(total_deaths as int)) as Total_Death_Count, MAX((total_deaths/population))*100 as Population_Death_Percent
--From [Portfolio Project]..covid_deaths
--Where continent is null
--Group By location
--Order By Total_Death_Count desc


----Global Numbers
--Select date, SUM(new_cases) as Total_Cases, SUM(cast(new_deaths as int)) as Total_Deaths, (SUM(cast(new_deaths as int))/SUM(new_cases))*100 as Death_Percentage
--From [Portfolio Project]..covid_deaths
--Where continent is not null
--Group By date
--Order By 1,2


----Total Population vs Vaccinations
----USE CTE
--With PopvsVac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
--as
--(
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order By dea.location, dea.date) as Rolling_People_Vaccinated
--From [Portfolio Project]..covid_deaths dea
--Join [Portfolio Project]..covid_vacinations vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--Where dea.continent is not null
----Order By 2,3
--)
--Select *, (RollingPeopleVaccinated/population)*100
--From PopvsVac


----TEMP TABLE
--Drop Table if exists #PercentPopulationVaccinated
--Create Table #PercentPopulationVaccinated
--(
--continent nvarchar(255), 
--location nvarchar(255), 
--date datetime, 
--population numeric, 
--new_vaccinations numeric, 
--Rolling_People_Vaccinated numeric
--)
--Insert into #PercentPopulationVaccinated
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order By dea.location, dea.date) as Rolling_People_Vaccinated
--From [Portfolio Project]..covid_deaths dea
--Join [Portfolio Project]..covid_vacinations vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--Where dea.continent is not null
----Order By 2,3

--Select *, (Rolling_People_Vaccinated/population)*100
--From #PercentPopulationVaccinated


----Creating view to store data for visualizations
--Create View PercentPopulationVaccinated as
--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order By dea.location, dea.date) as Rolling_People_Vaccinated
--From [Portfolio Project]..covid_deaths dea
--Join [Portfolio Project]..covid_vacinations vac
--	On dea.location = vac.location
--	and dea.date = vac.date
--Where dea.continent is not null
----Order By 2,3