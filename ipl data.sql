-- 1.	Show the percentage of wins of each bidder in the order of highest to lowest percentage.

SELECT BIDDER_ID,(no_of_wins/NO_OF_BIDS)*100 percentage_of_wins 
FROM ipl_bidder_points a INNER JOIN (SELECT BIDDER_ID,COUNT(WINNING) no_of_wins FROM 
(SELECT BIDDER_ID,CASE WHEN BID_STATUS='Won' THEN BID_STATUS END AS WINNING 
FROM ipl_bidding_details)t GROUP BY BIDDER_ID)b
USING (BIDDER_ID)
ORDER BY percentage_of_wins DESC;

# Tables used -- ipl_bidder_points (have details of bids),ipl_bidding_details ( have all the details of bidders )
# inner-most subquery (t) -- We selected bidder_id and only 'Won' bid_status (using CASE-WHEN) renamed as Winning from ipl_bidding_details 
# inner subquery (b) -- We selected bidder_id and count of winning(from subquery t) grouped by bidder_id from (t)
# We joined ipl_bidder_points as 'a' and subquery b using bidder_id . Frow which we selected bidder_id,
# and (no_of_wins/no_of_bids)*100 as percentage_of_wins -- to get the percentage of wins, ordered by percentage_of_wins in descending order
# because the question wanted us to show the percentage_of_wins of each bidder in the order of highest to lowest percentage.
# Output - 30 rows , 2 columns (bidder_id , percentage_of_wins)

-- 2.	Display the number of matches conducted at each stadium with the stadium name and city.es

SELECT STADIUM_NAME,CITY,COUNT(MATCH_ID) no_of_matches FROM ipl_stadium JOIN ipl_match_schedule USING (STADIUM_ID) GROUP BY STADIUM_ID;

# Tables used -- ipl_stadium( have all the details of stadiums ) , ipl_match_schedule (have all the details of matches)
# We joined ipl_stadium and ipl_match_schedule tables using stadium_id column and selected stadium_name,city and count(match_id) as no_of_matches
# grouped by stadium_id because the question wanted us to display the number of matches conducted at each stadium with the stadium name and city.
# Output -- 10 rows , 3 columns (stadium_name,city,no_of_matches

-- 3.	In a given stadium, what is the percentage of wins by a team which has won the toss?

select stadium_id , stadium_name ,
(select count(*) from ipl_match m join ipl_match_schedule ms on m.match_id = ms.match_id
where ms.stadium_id = s.stadium_id and (toss_winner = match_winner)) /
(select count(*) from ipl_match_schedule ms where ms.stadium_id = s.stadium_id) * 100 
as 'Percentage of Wins by teams who won the toss (%)'
from ipl_stadium s;

# Tables used - ipl_match_schedule (have all the details of match schedules), ipl_match (have all the details of matches) 
# and ipl_stadium (have all the details of stadiums)
# We used correlated subquery and joins to solve this question.
# subquery 1 - We joined ipl_match as m and ipl_match_schedule as ms using match_id only when (stadium_id in ms is equals to stadium_id in m.)
# and toss_winner is equals to match_winner. 
# subquery 2 - We selected count of all the rows where stadium_id in ms is equals to stadium_id of ipl_stadium (s) 
# Finally we selected stadium_id,stadium_name,subquery 1 and subquery 2 from ipl_stadium (alias - 's')
# because the question wanted the percentage of wins by a team which has won a toss.
# Output - 10 rows , 3 columns (stadium_id , stadium_name and 'percentage of wins by teams who won the toss (%)')

-- 4.	Show the total bids along with the bid team and team name.

SELECT TEAM_NAME,a.BID_TEAM,COUNT(a.BID_TEAM) TOTAL_BIDS FROM ipl_bidding_details a JOIN ipl_team b ON a.BID_TEAM=b.TEAM_ID GROUP BY BID_TEAM;

# tables used -- ipl_bidding_details (have all the details related to bids ) , ipl_team (have all the details related to the teams)
# We joined ipl_bidding_details as a and ipl_team as b using bid_team from a and team_id from b and selected team_name,bid_team and 
# count of bid_team as total_bids grouped by bid_team.
# because the demand of the question was to show the total bids along with the bid team and team name
# Output - 8 rows , 3 columns (team_name,bid_team and total_bids)

-- 5.	Show the team id who won the match as per the win details.

Select case
			when team_id1 = match_winner 
				then team_id1 
				else team_id2
		   end as "Team ID as per Win Details", win_details
    from IPL_Match;

# tables used -- ipl_match (consists details related to all the matches)
# We selected a columns which we created as 'Team ID as per win Details' using case when team_id1 is equals to match_winner then put team_id1 
# else put team_id2 in the columns and win_details from ipl_match table.
# Because the question wanted us to show the team id who won the match as per the win details.
# Output -- 120 rows , 2 columns ('team id as per win details' and win_details.



-- 6.	Display total matches played, total matches won and total matches lost by the team along with its team name.

select a.team_id,sum(MATCHES_PLAYED) as Total_matches_play,sum(MATCHES_WON) as  Total_matches_won
,sum(MATCHES_LOST)  Total_matches_lost,sum(NO_RESULT) as Tied_Matches ,TEAM_NAME 
from ipl_team_standings a inner join ipl_team b on a.TEAM_ID=b.TEAM_ID
group by a.TEAM_ID;


# Tables used -- ipl_team_standings (have details of all the matches related to teams) , ipl_team (have details of all the teams)
# We joined ipl_team_standings as a and ipl_team as b uisng team_id and selected team_id,sum of matches_played as total_matches_play , 
# sum of matches won as total_matches won , sum of matches lost as total_matches_lost , sum of no_result as tied_matches and team_name
# grouped by team_id.
# as the question wanted us to display total matches played , total matches won and total matches lost by the team along with its team name.
# Output -- 8 rows , 6 columns ( team_id,total_matches_play,total_matches_won,total_matches_lost,tied_matches and team_name)

-- 7.	Display the bowlers for the Mumbai Indians team.


select a.team_name ,b.player_role,b.player_id,c.player_name from ipl_team a inner join ipl_team_players b on
 a.TEAM_ID=b.TEAM_ID
inner join ipl_player c on b.PLAYER_ID=c.PLAYER_ID
where a.TEAM_name='mumbai indians'and PLAYER_ROLE='bowler';

# Tables used -- ipl_players (have details of players),ipl_team (have details of all the teams) and ipl_team_players ( have details of players)
# We first joined ipl_team as a to ipl_team_players as b using team_id and further joined the product table to ipl_player as c using player_id 
# Where team_name is equals to 'mumbai indians' and player_role is equals to 'bowler' & selected team_name,player_role,player_id and player_name.
# because the goal of the question was to display the bowlers for the mumbai indians team.
# Output -- 9 rows, 4 columns (team_name,player_role,player_id and player_name)




-- 8.	How many all-rounders are there in each team, Display the teams with more than 4 all-rounders in descending order.

select a.TEAM_ID,count(PLAYER_ROLE) no_of_allrounder ,PLAYER_ROLE,TEAM_NAME from ipl_team_players a inner join ipl_team b on a.TEAM_ID=b.TEAM_ID
where PLAYER_ROLE='All-Rounder' group by TEAM_ID having count(PLAYER_ROLE)>4 order  by count(PLAYER_ROLE) desc;

# Tables used -- ipl_team_players (consists details of team players) , ipl_team (have details of teams) 
# We joined ipl_team_players as a with ipl_team as b using team_id where player_role is 'All-Rounder' and selected team_id,count of player_role,player_role and team
# grouped by team_id which only had count of player_role greater than 4 and ordered it by count(player_role) in descending order.
# because the question wanted us to find how many all-rounders are there in each team amd only show those teams who have more than 4 all-rounders in descending order.
# Output -- 5 rows , 4 columns ( team_id,no_of_allrounder,player_role and team_name)

-- 9.	 Write a query to get the total bidders points for each bidding status of those bidders who bid on CSK when it won the match in 
-- M. Chinnaswamy Stadium bidding year-wise.
-- Note the total bidders’ points in descending order and the year is bidding year.
-- Display columns: bidding status, bid date as year, total bidder’s points

SELECT BID_STATUS,bid_year,TOTAL_POINTS FROM
(SELECT BID_STATUS,YEAR(bid_date) bid_year,TOTAL_POINTS,SCHEDULE_ID FROM ipl_bidder_points JOIN ipl_bidding_details USING (BIDDER_ID)
WHERE BID_TEAM = 1)t JOIN ipl_match_schedule USING (SCHEDULE_ID)
WHERE STADIUM_ID=7 AND BID_STATUS='Won' ORDER BY TOTAL_POINTS DESC;

# Tables used -- ipl_bidder_points (have all the details of bids and points ),ipl_bidding_details (have details of bids)
# inner query (t) -- We joined ipl_bidder_points with ipl_bidding_details using bidder_id where bid_team is equals to 1
# We joined subquery(t) with ipl_match_schedule using schedule_id where stadium_id is equals to 7 (M.Chinnaswamy Stadium)
# and bid_status is 'won' & selected bid_status , bid_year
# and total_points ordered by total_points in descending order.

# Output -- 2 rows , 3 columns (bid_status,bid_year and total_points)



-- 10.	Extract the Bowlers and All Rounders those are in the 5 highest number of wickets.
-- Note 
-- 1. use the performance_dtls column from ipl_player to get the total number of wickets
-- 2. Do not use the limit method because it might not give appropriate results when players have the same number of wickets
-- 3.	Do not use joins in any cases.
-- 4.	Display the following columns teamn_name, player_name, and player_role.



SELECT t1.team_name, p.player_name, PLAYER_ROLE 
FROM ipl_player p
INNER JOIN ipl_team_players tp ON p.PLAYER_ID = tp.PLAYER_ID
INNER JOIN ipl_team t1 ON tp.TEAM_ID = t1.TEAM_ID
WHERE PLAYER_ROLE IN ('Bowler', 'All-Rounder')
AND p.PLAYER_ID IN (
    SELECT PLAYER_ID FROM (
        SELECT player_id, 
        dense_rank() over (
            ORDER BY 
            substring(performance_dtls,instr(performance_dtls,'Wkt')+4,(instr(performance_dtls,'Dot')-5)-instr(performance_dtls,'Wkt')) DESC
        ) AS Ranks 
        FROM ipl_player 
        WHERE PLAYER_ROLE IN ('Bowler', 'All-Rounder')
    ) a
    WHERE Ranks <= 5
);


-- tables used -- ipl_player,ipl_team_players,ipl_team 
-- 'SELECT t1.team_name, p.player_name, p.PLAYER_ROLE' : Select the team name, player name, and player role from the ipl_team, ipl_player, and ipl_team_players tables.
-- 'FROM ipl_player p INNER JOIN ipl_team_players tp ON p.PLAYER_ID' = tp.PLAYER_ID INNER JOIN ipl_team t1 ON tp.TEAM_ID = t1.TEAM_ID: Join the ipl_player, ipl_team_players, 
-- and ipl_team tables using the player ID and team ID columns.
-- 'WHERE p.PLAYER_ROLE IN ('Bowler', 'All-Rounder')': Filter the results to include only players who are either bowlers or all-rounders.
-- 'AND p.PLAYER_ID IN (SELECT PLAYER_ID FROM (SELECT player_id, dense_rank() over (ORDER BY substring(performance_dtls,instr(performance_dtls,'Wkt')+4,
-- (instr(performance_dtls,'Dot')-5)-instr(performance_dtls,'Wkt')) DESC) AS Ranks FROM ipl_player WHERE PLAYER_ROLE IN ('Bowler', 'All-Rounder')) a WHERE Ranks <= 5)'
-- : Filter the results to include only players whose rank is less than or equal to 5, based on their performance statistics. 
-- The dense_rank() function is used to assign a rank to each player based on their performance, and the substring() function is used to extract the relevant performance statistics from 
-- the performance_dtls column.
-- In summary, this SQL query returns a list of team names, player names, and player roles for the top 5 bowlers and all-rounders based on their performance statistics.
-- Output -- 13 rows , 3 columns ( team_name , player_name and player_role)




-- 11.	show the percentage of toss wins of each bidder and display the results in descending order based on the percentage.

SELECT BIDDER_ID,BIDDER_NAME,perc_toss_wins FROM (SELECT BIDDER_ID,(total_toss_wins/total_bids)*100 perc_toss_wins FROM 
(SELECT BIDDER_ID,COUNT(BID_TEAM) total_bids,SUM(TOSS) total_toss_wins FROM (SELECT BIDDER_ID,BID_TEAM,
CASE WHEN BID_TEAM=TOSS_WINNER THEN 1 ELSE 0 END AS TOSS FROM 
(SELECT SCHEDULE_ID,MATCH_ID,TOSS_WINNER,TEAM_NAME FROM (SELECT SCHEDULE_ID,MATCH_ID,TOSS_WINNER FROM ipl_match a JOIN ipl_match_schedule 
USING (MATCH_ID))t 
JOIN ipl_team b ON t.TOSS_WINNER=b.team_id)tt JOIN ipl_bidding_details c ON tt.SCHEDULE_ID=c.SCHEDULE_ID)ttt
GROUP BY BIDDER_ID)tttt
ORDER BY perc_toss_wins DESC)ttttt JOIN ipl_bidder_details USING (BIDDER_ID);

-- The query selects the bidder ID, bidder name, and percentage of toss wins for each bidder from the ipl_bidder_details table. The percentage of toss wins is calculated by dividing the total 
-- number of toss wins by the total number of bids made by the bidder, and then multiplying the result by 100.
-- rTo calculate the total number of bids and toss wins for each bidder, the query joins the ipl_bidding_details and ipl_match_schedule tables to get the schedule ID and toss winner for each 
-- match, and then joins the ipl_team and ipl_bidding_details tables to get the team that the bidder placed a bid on. The query then counts the total number of bids and calculates the total 
-- number of toss wins for each bidder.
-- Finally, the query sorts the results by the percentage of toss wins in descending order and returns the results.


-- 12.	find the IPL season which has min duration and max duration.
-- Output columns should be like the below:
-- Tournment_ID, Tourment_name, Duration column, Duration

SELECT TOURNMT_ID,TOURNMT_NAME,DURATION FROM (SELECT TOURNMT_ID,TOURNMT_NAME,DURATION,DENSE_RANK() OVER(ORDER BY DURATION DESC) RANK_
FROM 
(SELECT Tournmt_id,tournmt_name,DATEDIFF(TO_DATE,FROM_DATE) DURATION FROM ipl_tournament)t
ORDER BY DURATION DESC)tt
WHERE RANK_ IN (1,5);

-- tables used -- ipl_tournament
-- The query selects the tournament ID, tournament name, and duration of each tournament from the ipl_tournament table. To calculate the duration of each tournament, the query subtracts the 
-- FROM_DATE from the TO_DATE.
-- The query then creates a derived table using a subquery that adds a rank column based on the duration of each tournament, calculated using the DENSE_RANK() function. The derived table is 
-- sorted in descending order of duration.
-- Finally, the query selects the rows from the derived table where the rank is either 1 or 5, and returns the tournament ID, tournament name, and duration of those tournaments.
-- Output -- 3 rows , 3 columns (tournament_id,tournament_name,duration


-- 13.	Write a query to display to calculate the total points month-wise for the 2017 bid year. 
-- sort the results based on total points in descending order and month-wise in ascending order.
-- Note: Display the following columns:
-- 1.	Bidder ID, 2. Bidder Name, 3. bid date as Year, 4. bid date as Month, 5. Total points
-- Only use joins for the above query queries.

SELECT DISTINCT a.BIDDER_ID,BIDDER_NAME,YEAR(BID_DATE) bid_date_as_year,MONTH(BID_DATE) bid_date_as_month,TOTAL_POINTS FROM ipl_bidding_details a JOIN 
ipl_bidder_details b USING(BIDDER_ID) JOIN ipl_bidder_points c ON b.BIDDER_ID=c.BIDDER_ID
WHERE YEAR(BID_DATE)=2017
ORDER BY MONTH(BID_DATE) ASC,TOTAL_POINTS DESC;

-- tables used -- ipl_bidding_details, ipl_bidder_details and ipl_bidder_points
-- The query selects distinct bidder IDs, bidder names, the year and month of the bid date, and the total points for each bid made in the year 2017.
-- It does this by joining the ipl_bidding_details table with the ipl_bidder_details table using the bidder ID, and then joining the result with the ipl_bidder_points table 
-- using the same bidder_ID.
-- It then filters the results to include only those bids made in the year 2017, and sorts them first by the month of the bid date in ascending order, and then by the total points in 
-- descending order.
-- Finally, the query returns the bidder ID, bidder name, year and month of the bid date, and total points for each bid that meets the specified criteria.
-- output -- 55 rows , 5 columns (bidder_id,bidder_name,bid_date_as_year,bid_date_as_month and total_points





-- 14.	Write a query for the above question using sub queries by having the same constraints as the above question.

SELECT DISTINCT BIDDER_ID,BIDDER_NAME,YEAR(BID_DATE) bid_date_as_year,MONTH(BID_DATE) bid_date_as_month,TOTAL_POINTS 
FROM ipl_bidding_details a JOIN (SELECT BIDDER_ID,BIDDER_NAME FROM ipl_bidder_details) b USING(BIDDER_ID)
JOIN (SELECT BIDDER_ID,TOTAL_POINTS FROM ipl_bidder_points) c USING (BIDDER_ID)
WHERE YEAR(BID_DATE)=2017
ORDER BY MONTH(BID_DATE) ASC,TOTAL_POINTS DESC;


-- tables used -- ipl_bidding_details,ipl_bidder_details and ipl_bidder_points
-- The query selects distinct bidder IDs, bidder names, the year and month of the bid date, and the total points for each bid made in the year 2017.
-- It does this by joining the ipl_bidding_details table with a subquery that selects only the bidder ID and bidder name from the ipl_bidder_details table using the bidder ID, and then 
-- joining the result with another subquery that selects only the bidder ID and total points from the ipl_bidder_points table using the same bidder ID.
-- It then filters the results to include only those bids made in the year 2017, and sorts them first by the month of the bid date in ascending order, and then by the total points in 
-- descending order.
-- Finally, the query returns the bidder ID, bidder name, year and month of the bid date, and total points for each bid that meets the specified criteria.
-- output -- 55 rows , 5 columns (bidder_id,bidder_name,bid_date_as_year,bid_date_as_month and total_points

-- 15.	Write a query to get the top 3 and bottom 3 bidders based on the total bidding points for the 2018 bidding year.
-- Output columns should be:
-- like:
-- Bidder Id, Ranks (optional), Total points, Highest_3_Bidders --> columns contains name of bidder, Lowest_3_Bidders  --> columns contains name of bidder;

SELECT BIDDER_ID,CASE WHEN R IN (1,2,3) THEN BIDDER_NAME END AS HIGHEST_3_BIDDERS,
CASE WHEN R IN (14,15,16) THEN  BIDDER_NAME END AS LOWEST_3_BIDDERS,TOTAL_POINTS FROM
(SELECT DISTINCT BIDDER_ID,BIDDER_NAME,YEAR(BID_DATE) bid_date_as_year,TOTAL_POINTS,DENSE_RANK() OVER(ORDER BY TOTAL_POINTS DESC) R
FROM ipl_bidding_details a JOIN (SELECT BIDDER_ID,BIDDER_NAME FROM ipl_bidder_details) b USING(BIDDER_ID) 
JOIN (SELECT BIDDER_ID,TOTAL_POINTS FROM ipl_bidder_points) c USING (BIDDER_ID) 
WHERE YEAR(BID_DATE)=2018
ORDER BY TOTAL_POINTS DESC)t
WHERE R IN (1,2,3,14,15,16);


-- tables used -- ipl_bidding_details,ipl_bidder_points,ipl_bidder_details
-- The query starts by selecting the distinct bidder IDs, bidder names, year of the bid date, total points, and a dense rank based on the total points earned for each bid made in the year 2018.
-- It does this by joining the ipl_bidding_details table with two subqueries that select only the bidder ID and bidder name from the ipl_bidder_details table using the bidder ID, 
-- and total points from the ipl_bidder_points table using the same bidder ID.
-- It then filters the results to include only bids made in the year 2018 and sorts them based on the total points in descending order.
-- The outer query then selects only the bidder ID, rank, and bidder name for bidders ranked in the top 3 and bottom 3 based on their total points earned.
-- It does this by using a CASE statement to include the bidder name in the result set only when their rank falls within the specified range.
-- Finally, the query returns the bidder ID, rank, bidder name, and total points for the top 3 highest bidders and bottom 3 lowest bidders that meet the specified criteria.
-- Output -- 10 rows , 4 columns (bidder_id,highest_3_bidders,lowest_3_bidders and total_points)


-- 16.	Create two tables called Student_details and Student_details_backup.

-- Table 1: Attributes 		Table 2: Attributes
-- Student id, Student name, mail id, mobile no.	Student id, student name, mail id, mobile no.

-- Feel free to add more columns the above one is just an example schema.
-- Assume you are working in an Ed-tech company namely Great Learning where you will be inserting and modifying the details of the students in the Student details table.
-- Every time the students changed their details like mobile number,
-- You need to update their details in the student details table.  Here is one thing you should ensure whenever the new students' details come , you should also store them in
-- the Student backup table so that if you modify the details in the student details table, you will be having the old details safely.
-- You need not insert the records separately into both tables rather Create a trigger in such a way that It should insert the details into the Student back table when you 
-- inserted the student details into the student table automatically.


CREATE TABLE Student_details (
  student_id INT PRIMARY KEY,
  student_name VARCHAR(50) NOT NULL,
  mail_id VARCHAR(50) NOT NULL,
  mobile_no VARCHAR(15) NOT NULL
);

CREATE TABLE Student_details_backup (
  student_id INT,
  student_name VARCHAR(50) NOT NULL,
  mail_id VARCHAR(50) NOT NULL,
  mobile_no VARCHAR(15) NOT NULL,
  backup_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER student_details_trigger 
AFTER INSERT ON Student_details 
FOR EACH ROW 
BEGIN 
  INSERT INTO Student_details_backup (student_id, student_name, mail_id, mobile_no) 
  VALUES (NEW.student_id, NEW.student_name, NEW.mail_id, NEW.mobile_no); 
END //

CREATE TRIGGER student_details_update_trigger 
AFTER UPDATE ON Student_details 
FOR EACH ROW 
BEGIN 
  INSERT INTO Student_details_backup (student_id, student_name, mail_id, mobile_no) 
  VALUES (OLD.student_id, OLD.student_name, OLD.mail_id, OLD.mobile_no); 
END //

DELIMITER ;


-- This SQL query creates a trigger called "backup_student_details" that is associated with the "Student_details" table. The trigger is set to execute 
-- "AFTER INSERT", meaning that it will activate after a new row is inserted into the "Student_details" table.
-- The "FOR EACH ROW" clause indicates that the trigger will execute for each row that is inserted into the "Student_details" table. This means that the trigger 
-- will be triggered once for every row that is inserted.
-- The "BEGIN...END" block contains the actual code that the trigger will execute. In this case, the code is a simple insert statement that will insert a new 
-- row into the "Student_details_backup" table with the same values as the newly inserted row in the "Student_details" table.
-- The "NEW" keyword is a reference to the newly inserted row in the "Student_details" table. By using "NEW.Student_id", "NEW.Student_name", "NEW.Mail_id",
-- and "NEW.Mobile_no" in the insert statement, we are telling MySQL to insert the corresponding values from the newly inserted row in the "Student_details" 
-- table into the "Student_details_backup" table.
-- Overall, this SQL query creates a trigger that will automatically backup the details of every new student that is added to the "Student_details" table, 
-- ensuring that the old details are safely stored in the "Student_details_backup" table.

# To check

INSERT INTO Student_details (student_id, student_name, mail_id, mobile_no)
VALUES (1, 'John Doe', 'johndoe@example.com', '1234567890');

UPDATE Student_details SET mobile_no = '1111111111' WHERE student_id = 1;















