--Cinco consultas que incluyan para su solución álgebra relacional y consulta en SQL.  

--Encontrar todas las consultas realizadas por el medico con id 3
SELECT MC.*, E.PILAEMP, E.RFC
FROM MEDICOCONSULTORIO MC
JOIN MEDICO M ON MC.ID_MED = M.ID_MED
JOIN PROFESIONAL P ON M.ID_PROF=P.ID_PROF
JOIN EMPLEADO E ON E.ID_EMP=P.ID_EMP
WHERE M.ID_MED = 3;

--Listar todos los monitores y computadoras en la habitación 2
SELECT * FROM MONITOR M
WHERE M.SUBRHABITACION = 2
UNION
SELECT * FROM COMPUTADORA C
WHERE C.SUBRHABITACION = 2;

--Obtener la lista de cirugías realizadas junto con sus resultados del quirofano 1
SELECT CP.RESULTADO 
FROM CIRQUIPACIENTE CP
JOIN CIRUJANOQUIROFANO CQ ON CP.SUBRCIRQUI = CQ.SUBRCIRQUI
WHERE CQ.ID_QUIRO = 1;

--Cirugías con resultado 'Reparación de aneurisma aórtico, paciente estable' y el id de el médico que lo atendio
SELECT cp.ID_PACIENTE, cp.FECHA, cp.RESULTADO
FROM CIRQUIPACIENTE cp
JOIN MEDICOCONSULTORIO mc ON cp.SUBRCIRQUI = mc.SUBRMEDCON
JOIN MEDICO m ON mc.ID_MED = m.ID_MED
WHERE cp.RESULTADO = 'Reparación de aneurisma aórtico, paciente estable';

--Diagnósticos y tratamientos de pacientes atendidos en enero de 2022
SELECT DIAGNOSTICO, TRATAMIENTO 
FROM MEDCONPACIENTE 
WHERE FECHA BETWEEN DATE '2022-01-01' AND DATE '2022-01-31';



--Dos consultas con diferentes tipos de joins (left join, rigth join, join, etc).  

-- Médicos y sus pacientes con diagnóstico de hipertensión arterial
SELECT MEDICOCONSULTORIO.ID_MED,EMPLEADO.PILAEMP, EMPLEADO.PATEMP, EMPLEADO.MATEMP, MEDCONPACIENTE.ID_PACIENTE, MEDCONPACIENTE.DIAGNOSTICO 
FROM MEDICOCONSULTORIO 
JOIN MEDCONPACIENTE ON MEDICOCONSULTORIO.SUBRMEDCON = MEDCONPACIENTE.SUBRMEDCON 
JOIN MEDICO ON MEDICOCONSULTORIO.ID_MED = MEDICO.ID_MED
JOIN PROFESIONAL ON MEDICO.ID_PROF = PROFESIONAL.ID_PROF
JOIN EMPLEADO ON PROFESIONAL.ID_EMP = EMPLEADO.ID_EMP
WHERE MEDCONPACIENTE.DIAGNOSTICO = 'Hipertensión arterial';

--Mostrar todos los médicos y sus consultorios asignados
SELECT M.ID_MED,EMPLEADO.PILAEMP, EMPLEADO.PATEMP, EMPLEADO.MATEMP, C.ID_CONSULTORIO
FROM MEDICO M
JOIN MEDICOCONSULTORIO MC ON M.ID_MED = MC.ID_MED
JOIN CONSULTORIO C ON MC.SUBRCONSULTORIO = C.SUBRCONSULTORIO
JOIN PROFESIONAL ON PROFESIONAL.ID_PROF = M.ID_PROF
JOIN EMPLEADO ON PROFESIONAL.ID_EMP = EMPLEADO.ID_EMP;

--Cirujanos y detalles de cirugías de los pacientes que fueron operados en junio de 2022
SELECT CIRUJANOQUIROFANO.ID_CIRU,EMPLEADO.PILAEMP, EMPLEADO.PATEMP, EMPLEADO.MATEMP, CIRQUIPACIENTE.ID_PACIENTE, CIRQUIPACIENTE.RESULTADO 
FROM CIRUJANOQUIROFANO 
LEFT JOIN CIRQUIPACIENTE ON CIRUJANOQUIROFANO.SUBRCIRQUI = CIRQUIPACIENTE.SUBRCIRQUI
LEFT JOIN CIRUJANO ON CIRUJANOQUIROFANO.ID_CIRU = CIRUJANO.ID_CIRU
LEFT JOIN MEDICO ON CIRUJANO.ID_MED = MEDICO.ID_MED
LEFT JOIN PROFESIONAL ON MEDICO.ID_PROF = PROFESIONAL.ID_PROF
LEFT JOIN EMPLEADO ON PROFESIONAL.ID_EMP = EMPLEADO.ID_EMP
WHERE CIRQUIPACIENTE.FECHA BETWEEN DATE '2022-06-01' AND DATE '2022-06-30';

--Pacientes junto con las fechas y horas de las observaciones realizadas por las enfermeras.
SELECT P.PILAPAC, P.PATPAC, P.MATPACIENTE, EP.FECHAHORA, EP.OBSERVACIONES
FROM PACIENTE P
LEFT JOIN ENFHABPACIENTE EP ON P.ID_PACIENTE = EP.ID_PACIENTE;


--Obtener información de los empleados y sus números de teléfono correspondientes solo de mujeres
SELECT E.PILAEMP, E.PATEMP, E.MATEMP, T.TELEFONO
FROM EMPLEADO E
RIGHT JOIN TELEFONOEMP T ON E.ID_EMP = T.ID_EMP
WHERE E.GENERO = 'FEMENINO';

--Obtener información detallada de los pacientes que han sido atendidos
--por enfermeras en habitaciones individuales, así como por médicos en consultorios.
SELECT 
    P.ID_PACIENTE,
    P.PILAPAC,
    P.PATPAC,
    P.MATPACIENTE,
    EH.ID_ENF,
    E.PILAEMP AS NOMBRE_ENFERMERA,
    E.PATEMP AS APELLIDO_PATERNO_ENFERMERA,
    E.MATEMP AS APELLIDO_MATERNO_ENFERMERA,
    H.ID_HABITACION,
    H.TIPO AS TIPO_HABITACION,
    MC.ID_MED,
    ME.PILAEMP AS NOMBRE_MEDICO,
    ME.PATEMP AS APELLIDO_PATERNO_MEDICO,
    ME.MATEMP AS APELLIDO_MATERNO_MEDICO,
    C.ID_CONSULTORIO AS ID_CONSULTORIO
FROM PACIENTE P
RIGHT JOIN ENFHABPACIENTE EHP ON P.ID_PACIENTE = EHP.ID_PACIENTE
RIGHT JOIN ENFERMERAHABITACION EH ON EHP.SUBRENFHAB = EH.SUBRENFHAB
RIGHT JOIN EMPLEADO E ON EH.ID_ENF = E.ID_EMP
RIGHT JOIN HABITACION H ON EH.SUBRHABITACION = H.SUBRHABITACION
RIGHT JOIN MEDCONPACIENTE MCP ON P.ID_PACIENTE = MCP.ID_PACIENTE
RIGHT JOIN MEDICOCONSULTORIO MC ON MCP.SUBRMEDCON = MC.SUBRMEDCON
RIGHT JOIN EMPLEADO ME ON MC.ID_MED = ME.ID_EMP
RIGHT JOIN CONSULTORIO C ON MC.SUBRCONSULTORIO = C.SUBRCONSULTORIO
WHERE H.TIPO = 'INDIVIDUAL' AND ME.GENERO = 'MASCULINO';



-- Consultas con contrastes de agregación 

-- Comparar el número de pacientes atendidos por cada médico en diferentes meses.
SELECT 
    MC.ID_MED, 
    E.PILAEMP AS NOMBRE_MEDICO,
    E.PATEMP AS APELLIDO_PATERNO,
    E.MATEMP AS APELLIDO_MATERNO,
    COUNT(CASE WHEN EXTRACT(MONTH FROM MCP.FECHA) = 02 THEN MCP.ID_PACIENTE END) AS PACIENTES_FEBRERO,
    COUNT(CASE WHEN EXTRACT(MONTH FROM MCP.FECHA) = 04 THEN MCP.ID_PACIENTE END) AS PACIENTES_ABRIL,
    COUNT(CASE WHEN EXTRACT(MONTH FROM MCP.FECHA) = 08 THEN MCP.ID_PACIENTE END) AS PACIENTES_AGOSTO
FROM MEDICOCONSULTORIO MC
JOIN MEDCONPACIENTE MCP ON MC.SUBRMEDCON = MCP.SUBRMEDCON
JOIN EMPLEADO E ON MC.ID_MED = E.ID_EMP
GROUP BY MC.ID_MED, E.PILAEMP, E.PATEMP, E.MATEMP
ORDER BY MC.ID_MED;

-- Comparar la ocupación de habitaciones por pacientes en diferentes meses
SELECT 
    EH.SUBRHABITACION,
    H.TIPO,
    H.ESTADO,
    COUNT(CASE WHEN EXTRACT(MONTH FROM EHP.FECHAHORA) = 1 THEN EHP.ID_PACIENTE END) AS PACIENTES_EN_ENERO,
    COUNT(CASE WHEN EXTRACT(MONTH FROM EHP.FECHAHORA) = 2 THEN EHP.ID_PACIENTE END) AS PACIENTES_EN_FEBRERO
FROM ENFERMERAHABITACION EH
JOIN ENFHABPACIENTE EHP ON EH.SUBRENFHAB = EHP.SUBRENFHAB
JOIN HABITACION H ON EH.SUBRHABITACION = H.SUBRHABITACION
GROUP BY EH.SUBRHABITACION, H.TIPO, H.ESTADO
ORDER BY EH.SUBRHABITACION;



--VISTAS

--Esta vista muestra las habitaciones junto con su tipo, estado, y las enfermeras asignadas a ellas,
--incluyendo los nombres completos de las enfermeras y las fechas de asignación.
CREATE VIEW Vista_Habitaciones_Enfermeras AS
SELECT 
    H.SUBRHABITACION,
    H.TIPO,
    H.ESTADO,
    E.PILAEMP AS NOMBRE_ENFERMERA,
    E.PATEMP AS APELLIDO_PATERNO,
    E.MATEMP AS APELLIDO_MATERNO,
    EH.FECHA AS FECHA_ASIGNACION
FROM HABITACION H
JOIN ENFERMERAHABITACION EH ON H.SUBRHABITACION = EH.SUBRHABITACION
JOIN ENFERMERA ENF ON EH.ID_ENF = ENF.ID_ENF
JOIN PROFESIONAL P ON ENF.ID_PROF = P.ID_PROF
JOIN EMPLEADO E ON P.ID_EMP = E.ID_EMP;

SELECT * FROM VISTA_HABITACIONES_ENFERMERAS;

--Esta vista muestra información detallada de las consultas médicas, 
--incluyendo el nombre del médico, el consultorio, el nombre del paciente,
-- y el diagnóstico y tratamiento realizados.
CREATE VIEW Vista_Consultas_Detalladas AS
SELECT 
    MCP.SUBRMEDCONPACIENTE,
    E.PILAEMP AS NOMBRE_MEDICO,
    E.PATEMP AS APELLIDO_PATERNO_MEDICO,
    E.MATEMP AS APELLIDO_MATERNO_MEDICO,
    C.ID_CONSULTORIO,
    P.PILAPAC AS NOMBRE_PACIENTE,
    P.PATPAC AS APELLIDO_PATERNO_PACIENTE,
    P.MATPACIENTE AS APELLIDO_MATERNO_PACIENTE,
    MCP.FECHA,
    MCP.DIAGNOSTICO,
    MCP.TRATAMIENTO
FROM MEDICOCONSULTORIO MC
JOIN MEDICO M ON MC.ID_MED = M.ID_MED
JOIN PROFESIONAL PR ON M.ID_PROF = PR.ID_PROF
JOIN EMPLEADO E ON PR.ID_EMP = E.ID_EMP
JOIN CONSULTORIO C ON MC.SUBRCONSULTORIO = C.SUBRCONSULTORIO
JOIN MEDCONPACIENTE MCP ON MC.SUBRMEDCON = MCP.SUBRMEDCON
JOIN PACIENTE P ON MCP.ID_PACIENTE = P.ID_PACIENTE;

SELECT * FROM VISTA_CONSULTAS_DETALLADAS;



--Dos procedimientos almacenados


--Revisa si hay alguna habitacion 
CREATE OR REPLACE FUNCTION HABITACION_OCUPADA(id_habitacion IN VARCHAR2) 
RETURN VARCHAR2 
IS
    v_ocupada VARCHAR2(10);
BEGIN
    -- Intenta obtener el estado de ocupación de la habitación
    SELECT ESTADO INTO v_ocupada 
    FROM HABITACION 
    WHERE ID_HABITACION = id_habitacion;

    -- Retorna el estado de ocupación
    RETURN v_ocupada;
    
EXCEPTION
    -- Manejo de excepciones en caso de que la habitación no exista
    WHEN NO_DATA_FOUND THEN
        RETURN 'Habitación no encontrada';
    WHEN OTHERS THEN
        RETURN 'Error en la consulta';
END;

--Calculo de edad de un paciente
CREATE OR REPLACE FUNCTION CalcularEdadPaciente(
    p_FechaNac DATE
) RETURN NUMBER IS
    v_Edad NUMBER;
BEGIN
    SELECT FLOOR(MONTHS_BETWEEN(SYSDATE, p_FechaNac) / 12)
    INTO v_Edad
    FROM DUAL;

    RETURN v_Edad;
END;


--Actualizar Datos de un Empleado y sus Teléfonos
CREATE OR REPLACE PROCEDURE ActualizarEmpleadoYTelefonos(
    p_ID_Emp NUMBER,
    p_RFC CHAR,
    p_NSS CHAR,
    p_FechaNac DATE,
    p_Genero VARCHAR2,
    p_PilaEmp VARCHAR2,
    p_PatEmp VARCHAR2,
    p_MatEmp VARCHAR2,
    p_CalleEmp VARCHAR2,
    p_ColEmp VARCHAR2,
    p_EstadoEmp VARCHAR2,
    p_Telefono1 CHAR,
    p_Telefono2 CHAR
) AS
BEGIN
    -- Actualizar datos del empleado
    UPDATE EMPLEADO
    SET RFC = p_RFC,
        NSS = p_NSS,
        FECHANAC = p_FechaNac,
        GENERO = p_Genero,
        PILAEMP = p_PilaEmp,
        PATEMP = p_PatEmp,
        MATEMP = p_MatEmp,
        CALLE_EMP = p_CalleEmp,
        COLEMP = p_ColEmp,
        ESTADOEMP = p_EstadoEmp
    WHERE ID_EMP = p_ID_Emp;

    -- Actualizar el primer teléfono
    UPDATE TELEFONOEMP
    SET TELEFONO = p_Telefono1
    WHERE ID_EMP = p_ID_Emp
      AND SUBRTELEMP = 1;

    -- Actualizar el segundo teléfono
    UPDATE TELEFONOEMP
    SET TELEFONO = p_Telefono2
    WHERE ID_EMP = p_ID_Emp
      AND SUBRTELEMP = 2;

    COMMIT;
END;


--Asignar Médico a Consultorio
CREATE OR REPLACE PROCEDURE AsignarMedicoAConsultorio(
    p_ID_Med NUMBER,
    p_SubrConsultorio NUMBER,
    p_Fecha DATE
) AS
BEGIN
    -- Verificar que el médico no esté asignado a otro consultorio en la misma fecha
    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM MEDICOCONSULTORIO
        WHERE ID_MED = p_ID_Med
          AND FECHA = p_Fecha;

        IF v_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'El médico ya está asignado a otro consultorio en la fecha especificada.');
        END IF;
    END;

    -- Asignar el médico al consultorio
    INSERT INTO MEDICOCONSULTORIO (SUBRMEDCON, ID_MED, SUBRCONSULTORIO, FECHA)
    VALUES (
        (SELECT NVL(MAX(SUBRMEDCON), 0) + 1 FROM MEDICOCONSULTORIO), -- Generación del nuevo ID
        p_ID_Med,
        p_SubrConsultorio,
        p_Fecha
    );

    COMMIT;
END;



--Trigger

CREATE OR REPLACE TRIGGER trg_previene_insercion
BEFORE INSERT ON HABITACION
FOR EACH ROW
DECLARE
    v_estado VARCHAR2(10);
BEGIN
    -- Llama a la función para verificar si la habitación está ocupada
    v_estado := HABITACION_OCUPADA(:NEW.ID_HABITACION);
    
    -- Si la habitación está ocupada, lanza una excepción
    IF v_estado = 'OCUPADA' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Habitación ocupada');
    END IF;
END;