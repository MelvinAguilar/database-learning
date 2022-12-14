CREATE TABLE HOSPITAL (
id INT PRIMARY KEY,
nombre VARCHAR2(256),
area INT
);

CREATE TABLE AMBULANCIA (
    id INT PRIMARY KEY,
    placa CHAR(6),
    kilometraje INT,
    fecha_adquisicion DATE,
    id_conductor INT,
    id_origen INT,
    id_destino INT
);

ALTER TABLE AMBULANCIA ADD FOREIGN KEY (id_origen) REFERENCES HOSPITAL (id);
ALTER TABLE AMBULANCIA ADD FOREIGN KEY (id_destino) REFERENCES HOSPITAL (id);

INSERT INTO HOSPITAL VALUES(1,'Hospital Nacional "Arturo Morales"',1);
INSERT INTO HOSPITAL VALUES(2,'Hospital Nacional de Chalchuapa',1);
INSERT INTO HOSPITAL VALUES(3,'Hospital Nacional de Ilobasco',1);
INSERT INTO HOSPITAL VALUES(4,'Hospital Nacional de Jiquilisco',1);
INSERT INTO HOSPITAL VALUES(5,'Hospital Nacional de La Mujer',2);
INSERT INTO HOSPITAL VALUES(6,'Hospital Nacional de Nueva Guadalupe',2);
INSERT INTO HOSPITAL VALUES(7,'Hospital Nacional "Dr. Jorge Arturo Mena"',2);
INSERT INTO HOSPITAL VALUES(8,'Hospital Nacional "Dr. Juan Jos? Fern?ndez"',2);
INSERT INTO HOSPITAL VALUES(9,'Hospital Nacional "Benjam?n Bloom"',3);
INSERT INTO HOSPITAL VALUES(10,'Hospital Nacional "Rosales"',3);
INSERT INTO HOSPITAL VALUES(11,'Hospital Nacional Francisco Men?ndez',3);
INSERT INTO HOSPITAL VALUES(12,'HNLU - Hospital Nacional de la Uni?n',3);

INSERT INTO AMBULANCIA VALUES(1,'34F71',75711,TO_DATE('1/11/2020', 'DD/MM/YYYY'),8,NULL,NULL);
INSERT INTO AMBULANCIA VALUES(2,'3753E',31255,TO_DATE('2/11/2020', 'DD/MM/YYYY'),45,NULL,NULL);
INSERT INTO AMBULANCIA VALUES(3,'5368D',112215,TO_DATE('3/11/2020', 'DD/MM/YYYY'),46,NULL,NULL);
INSERT INTO AMBULANCIA VALUES(4,'5739C',68308,TO_DATE('4/11/2020', 'DD/MM/YYYY'),15,NULL,NULL);
INSERT INTO AMBULANCIA VALUES(5,'DF431',56779,TO_DATE('5/11/2020', 'DD/MM/YYYY'),12,NULL,NULL);
INSERT INTO AMBULANCIA VALUES(6,'644EC',78148,TO_DATE('6/11/2020', 'DD/MM/YYYY'),37,NULL,NULL);
INSERT INTO AMBULANCIA VALUES(7,'E83D1',70868,TO_DATE('7/11/2020', 'DD/MM/YYYY'),19,NULL,NULL);
INSERT INTO AMBULANCIA VALUES(8,'16D62',63199,TO_DATE('8/11/2020', 'DD/MM/YYYY'),12,NULL,NULL);
INSERT INTO AMBULANCIA VALUES(9,'E1278',65914,TO_DATE('9/11/2020', 'DD/MM/YYYY'),9,NULL,NULL);
INSERT INTO AMBULANCIA VALUES(10,'D9094',99637,TO_DATE('10/11/2020', 'DD/MM/YYYY'),12,NULL,NULL);
INSERT INTO AMBULANCIA VALUES(11,'197FB',61079,TO_DATE('11/11/2020', 'DD/MM/YYYY'),12,NULL,NULL);
INSERT INTO AMBULANCIA VALUES(12,'DBECA',29900,TO_DATE('12/11/2020', 'DD/MM/YYYY'),5,NULL,NULL);
INSERT INTO AMBULANCIA VALUES(13,'62A35',74138,TO_DATE('13/11/2020', 'DD/MM/YYYY'),24,NULL,NULL);
INSERT INTO AMBULANCIA VALUES(14,'EFF65',100765,TO_DATE('14/11/2020', 'DD/MM/YYYY'),6,NULL,NULL);
INSERT INTO AMBULANCIA VALUES(15,'513F9',78371,TO_DATE('15/11/2020', 'DD/MM/YYYY'),43,NULL,NULL);
INSERT INTO AMBULANCIA VALUES(16,'E29D4',83589,TO_DATE('16/11/2020', 'DD/MM/YYYY'),34,NULL,NULL);
INSERT INTO AMBULANCIA VALUES(17,'67E2B',78462,TO_DATE('17/11/2020', 'DD/MM/YYYY'),9,NULL,NULL);
INSERT INTO AMBULANCIA VALUES(18,'60EDA',30176,TO_DATE('18/11/2020', 'DD/MM/YYYY'),33,NULL,NULL);
INSERT INTO AMBULANCIA VALUES(19,'5B23A',40877,TO_DATE('19/11/2020', 'DD/MM/YYYY'),33,NULL,NULL);
INSERT INTO AMBULANCIA VALUES(20,'558AC',29032,TO_DATE('20/11/2020', 'DD/MM/YYYY'),43,NULL,NULL);

COMMIT;

SELECT * FROM HOSPITAL;
SELECT * FROM AMBULANCIA;
    