
Create Table Passenger (
PassengerID Number(5)       Primary key,
Name        Varchar2(50)    Not NUll,
Address     Varchar2(100)   Not NUll,
City        Varchar2(100)   Not NUll,
State       char(2)         Not Null,
Phone       Varchar2(20)    Not Null);



--insert some sequence values
('Maria Soto', '123 6th St. Melbourne', 'FL', '111-111-1111');
('Morris Bass', '71 Pilgrim Avenue', 'MD', '222-222-2222');
('Stella Walton', '70 Bowman St. South Windsor','CT','999-999-9999');
('Marco Cooper', '910 Creekside St. Eastlake','OH','333-333-3333');
('Ana Cook', '3 Lake Street West',' Deptford', 'NJ','444-444-4444'); 
('Leah Pratt', '745 Spring Street Loxahatchee','FL','111-555-5555');
('Clyde Bailey', '7366 Aspen Dr.Burbank','IL','666-666-6666');
('Angie Strickland', '8024 Sringfield Gardens','NY','777-777-7777');
('Lora Cummings', '265 Columbia Lane Pensacola','FL','111-888-8888');

--QUESTION 1
--make a sequence
Create Sequence Pass_ID
start with 1000
increment by 1;


--create procedure for register 
create or replace
PROCEDURE REGISTER_PASSENGER 
(p_name	in Passenger.Name%type,
 p_address in Passenger.Address%type,
 p_city	in Passenger.City%type,
 p_state in Passenger.State%type,
 p_phone in Passenger.Phone%type)
as
  P_id integer := pass_ID.nextval;
BEGIN
 insert into Passenger (PassengerID, Name, Address, City, State, Phone)
 values (P_id, p_name, p_address, p_city, p_state, p_phone); 
 DBMS_output.put_line(p_name || ' ' || p_address || ' ' || p_city || ' ' || p_state || ' ' || p_phone );
 DBMS_output.put_line( 'successfully registered,' || ' passenger ID is: ' || P_id);
end REGISTER_PASSENGER;

--executing the register procedure 
execute Register_Passenger ('Maria Soto', '123 6th St. Melbourne', 'FL', '111-111-1111');



--QUESTION 2

create or replace
PROCEDURE DISPLAY_FLIGHT(
  p_source in Flight.source%TYPE,
  p_destination	in flight.Destination%TYPE,
  p_date in flight.FlightDate%TYPE) 
AS
  f_fnumber flight.flightnumber%type;
  f_source     	Flight.source%TYPE;
  f_destination	flight.Destination%TYPE;
  f_date    	flight.FlightDate%TYPE;
  f_fare    	flight.Fare%TYPE;
BEGIN
 SELECT flightnumber, source, Destination, FlightDate, Fare
 INTO f_fnumber,f_source, f_destination, f_date, f_fare
 FROM flight
 WHERE source = p_source and destination = p_destination and flightdate = p_date;
 --DBMS_OUTPUT.PUT_LINE('FlightNumber'|| ' ' || 'Source' || ' ' || 'Destination' || ' ' || 'Flight Date' || ' ' || 'Flight Fare' );
 DBMS_OUTPUT.PUT_LINE(f_fnumber|| ' ' || f_source || '  ' || f_destination || ' ' || f_date || ' ' || f_fare );
END DISPLAY_FLIGHT;
end; 

execute display_flight(‘jfk’, ‘Florida’, ’01-JAN-2017’);

question 3

Create Sequence res_ID
start with 001
increment by 1;

--customer reservation
create or replace
PROCEDURE MAKE_RESERVATION (
  p_id in Passenger.PassengerID%type,
  p_fnumber in flight.flightnumber%type,
  p_num_of_seats in flight.num_of_Seats_Remaining%type)
AS 
 r_id integer := res_ID.nextval;
 pid Passenger.PassengerID%type;
 fnumber flight.flightnumber%type;
 f_date flight.FlightDate%type;
 /*f_num_of_seats flight.num_of_Seats_Remaining%type;*/
BEGIN

select case when exists (select passengerID from passenger where passengerID = p_id)
then 1
else 0
end into pid
from dual;

select case when exists (select flightNumber from Flight where Flightnumber = p_fnumber)
then 1
else 0 
end into fnumber
from dual;

select FlightDate INTO f_date
FROM Flight
WHERE FlightNumber = p_fnumber;

if pid = 1 and fnumber = 1
then insert into Reservation values (r_id, p_id, p_fnumber, f_date);
    Update flight 
    set NUM_OF_SEATS_REMAINING = NUM_OF_SEATS_REMAINING - p_num_of_seats
    where flightnumber = p_fnumber;
    DBMS_OUTPUT.PUT_LINE ('The customer ' ||  p_id || ' has made the reservation on flight ' || p_fnumber || ' with ' || p_num_of_seats || ' seats confirmed.');
    END IF;
 /*SELECT PassengerID, FlightNumber, FlightDate, num_of_Seats_Remaining
 INTO pid, f_fnumber, f_date, f_num_of_seats
 FROM Passenger, Flight
 INNER JOIN Paseengers ON Reservation.PassengerID = Passenger.PassengerID)
 INNER JOIN Flight ON Reservation.FlightNumber = Flight.FlightNumber)*/
END MAKE_RESERVATION;

execute Make_Reservation (1000, 'F111', 2);


question 4

create or replace
PROCEDURE DISPLAY_RESERVATION 
(PID in Reservation.PassengerID%TYPE)
AS
  r_id Reservation.reservationid%TYPE;
  p_id Reservation.passengerid%TYPE;
  f_fnumber Reservation.flightnumber%TYPE;
  f_date Reservation.flightdate%TYPE;
  f_source flight.source%type;
  f_dest flight.destination%type;
  f_fare flight.fare%type;
BEGIN
  SELECT r.ReservationID, r.PassengerID, r.Flightnumber, r.Flightdate, f.source, f.destination, f.fare
  INTO r_id, p_id, f_fnumber, f_date, f_source, f_dest, f_fare
  FROM Reservation r
  inner join flight f on r.flightnumber = f.flightnumber
  WHERE PassengerID = PID;
  DBMS_OUTPUT.PUT_LINE('Reservation ID: ' || r_id || ' ' || ' Passenger ID: ' || p_id || ' ' || ' Flight Number: ' || f_fnumber || ' ' || ' Flight Date ' || f_date ||
  ' source: ' || f_source || ' destination : ' || f_dest || ' fare : ' || f_fare);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Passenger ID ' || p_id || ' is not valid.');
    DBMS_OUTPUT.PUT_LINE('Please specify a valid passenger id');
END DISPLAY_RESERVATION;


--admin view flight
CREATE OR REPLACE PROCEDURE VIEW_FLIGHT
(p_source in Flight.source%TYPE)
AS 
  f_fnumber flight.flightnumber%type;
  f_source     	Flight.source%TYPE;
  f_destination	flight.Destination%TYPE;
  f_date    	flight.FlightDate%TYPE;
  f_fare    	flight.Fare%TYPE;
  f_num_of_seat Flight.Num_of_Seats_Remaining%TYPE;
  f_name  flight.AirlineName%TYPE;
BEGIN
 SELECT FlightNumber, Source, Destination, FlightDate, Fare, Num_of_Seats_Remaining, AirlineName
 INTO f_fnumber,f_source, f_destination, f_date, f_fare, f_num_of_seat, f_name
 FROM flight
 WHERE source = p_source;
 DBMS_OUTPUT.PUT_LINE(f_fnumber|| ' ' || f_source || '  ' || f_destination || ' ' || f_date || ' ' || f_fare || ' ' || f_name);
END VIEW_FLIGHT;

--executing flight
execute VIEW_FLIGHT('JFK');




--update fare
CREATE or REPLACE
PROCEDURE UPDATE_FARE
(p_fnumber flight.flightnumber%type)
AS
  f_fare    	flight.Fare%TYPE;
BEGIN
 UPDATE Flight 
 SET Fare = f_fare
 WHERE FlightNumber = p_fnumber;
 DBMS_OUTPUT.PUT_LINE('Flight number ' || f_fnumber || ' fare has been changed to ' || f_fare );	 
END

excute UPDATE_FARE(f111, 500);


--admin view reservation
create or replace
PROCEDURE VIEW_RESERVATION
(f_number in Flight.flightnumber%TYPE)
AS 
  r_id Reservation.reservationid%TYPE;
  p_id Reservation.passengerid%TYPE;
  f_fnumber Reservation.flightnumber%TYPE;
  f_date Reservation.flightdate%TYPE;
BEGIN
  SELECT ReservationID, PassengerID, Flightnumber, Flightdate
  INTO r_id, p_id, f_fnumber, f_date
  FROM Reservation
  WHERE Flightnumber = f_number;
  DBMS_OUTPUT.PUT_LINE(r_id || ' ' || p_id || ' ' || f_fnumber || ' ' || f_date);
END VIEW_RESERVATION;

--add flight
CREATE or REPLACE
PROCEDURE ADD_FLIGHT
 (f_fnumber flight.flightnumber%type,
  f_source     	Flight.source%TYPE,
  f_destination	flight.Destination%TYPE,
  f_date    	flight.FlightDate%TYPE,
  f_fare    	flight.Fare%TYPE,
  f_num_of_seat Flight.Num_of_Seats_Remaining
  f_name	flight.AirlineName);
AS
BEGIN
 INSERT INTO FLIGHT (FlightNumber, source, Destination, Fare, FlightDate, Num_of_Seats_Remaining, AirlineName)
 VALUES (f_fnumber, f_source, f_destination, f_date, f_fare, f_num_of_seat, f_name)
 DBMS_OUTPUT.PUT_LINE('Flight: ' || f_fnumber|| ' ' || 'Source: ' || f_source || '  ' || 'Destination: ' || f_destination || ' ' || 'Date: ' || f_date || ' ' || 'Fare: ' ||f_fare || ' ' || 'Number of seats remaining ' || f_num_of_seat || ' ' || 'Airline Name: ' || f_name || ' successfully added');
END;

execute ADD_FLIGHT(F777, 'JFK', 'Las Vegas', 400, ’20-JAN-2018’, 50, 'Jet Blue');

--admin view customer info
create or replace
PROCEDURE VIEW_CUSTOMER 
(p_id	 Passenger.PassengerID%type)
AS
 pid	 Passenger.PassengerID%type;
 p_name	 Passenger.Name%type;
 p_address  Passenger.Address%type;
 p_city	 Passenger.City%type;
 p_state  Passenger.State%type;
 p_phone  Passenger.Phone%type;
 fnumber flight.flightnumber%type;
 f_source flight.source%type;
 f_dest flight.destination%type;
 f_fare flight.Fare%type;
 f_date flight.flightDate%type;
 f_name flight.airlinename%type;
 r_id Reservation.ReservationID%type;
 
BEGIN
 SELECT p.passengerid, p.name, p.address, p.city, p.state, p.phone, f.flightnumber, f.source, f.destination, f.fare, f.flightdate, f.airlinename, r.reservationid
 INTO pid, p_name, p_address, p_city, p_state, p_phone, fnumber, f_source, f_dest, f_fare, f_date, f_name, r_id
 FROM Passenger p
 inner join Reservation r on p.passengerid = r.passengerid 
 inner join Flight f on r.flightnumber = f.flightnumber 
 WHERE p.PassengerID = p_id;
 DBMS_output.put_line(p_id || ' Name: ' || p_name || ' address: ' || p_address || ' City: ' || p_city || ' State: ' || p_state || ' Phone: ' || p_phone);
 DBMS_output.put_line('FlightNumber: ' || fnumber || ' Source: ' || f_source || ' Destination: ' || f_dest || ' Fare: ' || f_fare || ' Flightdate: ' || f_date);
 DBMS_output.put_line('AirlineName: ' || f_name || ' Reservation ID: ' || r_id); 
END VIEW_CUSTOMER;

set serveroutput on
execute VIEW_CUSTOMER('1000');