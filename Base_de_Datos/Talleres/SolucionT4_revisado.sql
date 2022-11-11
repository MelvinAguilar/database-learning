CREATE OR ALTER PROCEDURE AGREGAR_CITAS
    @id_clinica INT, 
    @id_cliente INT,
    @fecha VARCHAR(32)
AS BEGIN
    -- DECLARACION DE VARIABLES
    DECLARE @citas_activas INT;
    DECLARE @consultorios_disponibles INT;
    DECLARE @medicos_disponibles INT;
    DECLARE @hora_cita TIME;
    DECLARE @id_ultimo INT;

    -- PROCESAMIENTO DE DATOS
    -- Extraer el ultimo ID, ya que no es autoincrementable
    SELECT @id_ultimo = MAX(id) FROM CITA;

    -- Extraer hora de la cita
    SET @hora_cita = CONVERT(TIME, CONVERT(DATETIME, @fecha, 103))

    -- Citas que estan en el mismo horario que la ingresada
    SELECT @citas_activas = COUNT(*) 
    FROM CITA 
    WHERE id_clinica = @id_clinica AND fecha = CONVERT(DATETIME, @fecha, 103);

    -- Consultorios disponibles en X clinica
    SELECT @consultorios_disponibles = COUNT(*)
    FROM CONSULTORIO
    WHERE id_clinica = @id_clinica;

    -- Medicos de la clinica disponibles a la misma hora que la cita
    SELECT @medicos_disponibles = COUNT(*)
    FROM CONTRATO
    WHERE id_clinica = @id_clinica AND
        @hora_cita BETWEEN CONVERT(TIME, SUBSTRING(horario, 1, 7)) AND CONVERT(TIME, SUBSTRING(horario, 11, 18));

    IF @citas_activas < @consultorios_disponibles
        BEGIN
            IF @medicos_disponibles > @citas_activas
                BEGIN
                    INSERT INTO CITA VALUES( (@id_ultimo + 1), @id_clinica, @id_cliente, CONVERT(DATETIME, @fecha, 103));
                    PRINT('La cita ha sido almacenada exitosamente.');
                END;
            ELSE
                BEGIN
                    PRINT('ERROR: No se ha podido agregar la cita debido a falta de disponibilidad de médicos.');
                END;
        END;
    ELSE
        BEGIN
            PRINT('ERROR: No es posible realizar la cita, por que no hay cupos disponibles. :C');
        END;
END

-- EXEC AGREGAR_CITAS 1, 3, '20-05-2022 09:00:00.000'
-- EXEC AGREGAR_CITAS 1, 5, '20-05-2022 09:00:00.000'
-- EXEC AGREGAR_CITAS 6, 6, '21-05-2022 09:00:00.000'