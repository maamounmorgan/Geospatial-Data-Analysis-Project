# Strategic Location Analysis using Spatial Data

## Project Summary

This project aims to extract valuable strategic insights from Geospatial Data to support decision-making in various strategic sectors, including **Talent Management and Urban Planning**. Through advanced geographical analysis, we uncover complex spatial relationships that impact key areas such as **talent retention, competitive zone identification, and logistics optimization**.

## Data Used

This analysis relied on various types of spatial data:

* **Employee Data (`employee`):** Geographic locations of employees (point `geom`), representing their residences or workplaces, used to assess their proximity to competitors.
* **Company Data (`company`):** Geographic locations of companies (point `geom`), including both your company and major competitors, used to define areas of influence and overlap.
* **Street Network Data (`str`):** Lines representing streets (line `geom`), used to calculate street intersections and network density in different areas.
* **Borough Data (`boro`):** Geographic polygons (polygon `geom`) representing administrative divisions, used to calculate street intersection density within each area and identify high-density zones.

## Tools and Technologies

The following powerful tools and technologies were utilized to complete this project:

* **PostGIS:** For managing spatial databases and executing complex geographical queries.
* **SQL:** For writing queries, extracting, and analyzing data.
* **Power BI:** For designing interactive dashboards and effectively visualizing spatial insights.
* **GIS Concepts:** Including Buffer Analysis, Spatial Joins, and Density Analysis.

## Key Insights and Results

This project reveals several crucial strategic insights:

### 1. Employee Proximity to Competitors

* **Insight:** Identifying the Employee ID that overlaps with the highest number of competitor zones, highlighting **most overlapping employees with competitive zones**.
* **Metrics:** Average distance to nearest competitor: **2039 meters**.

### 2. Competitive Overlap Zones

* **Insight:** Uncovering geographical areas where competitor influence zones overlap.
* **Metrics:** Total overlapping competitive area: **552 km²**.

### 3. Street Network Density

* **Insight:** Analyzing the density of street intersections to determine the complexity of the road network and accessibility in various geographical areas.
* **Metrics:**
    * Total number of street intersections: **48K intersections**.
    * Street intersection density per sq. km: **80 intersections/km²**.

## Power BI Dashboard Screenshots

![Screenshot of Home Page](images/Home Page.png)
![Screenshot of Distance Analysis](images/Distance Analysis.png)
![Screenshot of Overlapping Employees](images/Overlapping Employees.png)
![Screenshot of Junction Density](images/Junction Density.png)

## Project Components

This repository contains the following components:

* `sql/`: All PostGIS and SQL queries used for the analysis.
* `powerbi_dashboard/`: The Power BI Desktop (`.pbix`) file for the interactive dashboards.
* `images/`: Screenshots of the Power BI dashboards to showcase the project.

## Contact Info

**Maamoun Mohamed Mohamed Morgan**
[LinkedIn Profile](https://www.linkedin.com/in/maamoun-morgan/)