CREATE OR REPLACE TRIGGER UPD_MARCADOR
    BEFORE UPDATE ON MARCADOR
    FOR EACH ROW
DECLARE
    LOCAL PARTIDOS.EQUI_LOC_PAR%TYPE;
    VISITANTE PARTIDOS.EQUI_VIS_PAR%TYPE;
    NUMPAR NUMBER := :OLD.NUM_PAR_MAR;
    GOLEQUILOC NUMBER := :OLD.GOL_EQUI_LOC_MAR;
    GOLEQUIVIS NUMBER := :OLD.GOL_EQUI_VIS_MAR;
    GOLFAVLOC POSICIONES.GOL_FAV_POS%TYPE;
    GOLFAVVIS POSICIONES.GOL_FAV_POS%TYPE;
    GOLCONLOC POSICIONES.GOL_CON_POS%TYPE;
    GOLCONVIS POSICIONES.GOL_CON_POS%TYPE;
    PARTGANLOC POSICIONES.PAR_GAN_POS%TYPE;
    PARTGANVIS POSICIONES.PAR_GAN_POS%TYPE;
    PARTPERLOC POSICIONES.PAR_PER_POS%TYPE;
    PARTPERVIS POSICIONES.PAR_PER_POS%TYPE;
    PARTEMPLOC POSICIONES.PAR_EMP_POS%TYPE;
    PARTEMPVIS POSICIONES.PAR_EMP_POS%TYPE;
    PUNTLOC POSICIONES.PUNTOS_POS%TYPE;
    PUNTVIS POSICIONES.PUNTOS_POS%TYPE;
    PUNTGAN POSICIONES.PUNTOS_POS%TYPE;
    PUNTPER POSICIONES.PUNTOS_POS%TYPE;
    PUNTEMPLOC POSICIONES.PUNTOS_POS%TYPE;
    PUNTEMPVIS POSICIONES.PUNTOS_POS%TYPE;
BEGIN
    SELECT EQUI_LOC_PAR INTO LOCAL
    FROM PARTIDOS
    WHERE NUM_PAR = NUMPAR;

    SELECT EQUI_VIS_PAR INTO VISITANTE
    FROM PARTIDOS
    WHERE NUM_PAR = NUMPAR;

    SELECT PAR_GAN_POS INTO PARTGANLOC
    FROM POSICIONES
    WHERE EQUIPO_POS = LOCAL;

    SELECT PAR_GAN_POS INTO PARTGANVIS
    FROM POSICIONES
    WHERE EQUIPO_POS = VISITANTE;

    SELECT PAR_PER_POS INTO PARTPERLOC
    FROM POSICIONES
    WHERE EQUIPO_POS = LOCAL;

    SELECT PAR_PER_POS INTO PARTPERVIS
    FROM POSICIONES
    WHERE EQUIPO_POS = VISITANTE;

    SELECT PAR_EMP_POS INTO PARTEMPLOC
    FROM POSICIONES
    WHERE EQUIPO_POS = LOCAL;

    SELECT PAR_EMP_POS INTO PARTEMPVIS
    FROM POSICIONES
    WHERE EQUIPO_POS = VISITANTE;

    SELECT PUNTOS_POS INTO PUNTLOC
    FROM POSICIONES
    WHERE EQUIPO_POS = LOCAL;

    SELECT PUNTOS_POS INTO PUNTVIS
    FROM POSICIONES
    WHERE EQUIPO_POS = VISITANTE;

    SELECT GOL_FAV_POS INTO GOLFAVLOC
    FROM POSICIONES
    WHERE EQUIPO_POS = LOCAL;

    SELECT GOL_FAV_POS INTO GOLFAVVIS
    FROM POSICIONES
    WHERE EQUIPO_POS = VISITANTE;

    SELECT GOL_CON_POS INTO GOLCONLOC
    FROM POSICIONES
    WHERE EQUIPO_POS = LOCAL;

    SELECT GOL_CON_POS INTO GOLCONVIS
    FROM POSICIONES
    WHERE EQUIPO_POS = VISITANTE;

    IF (GOLEQUILOC > GOLEQUIVIS) THEN
        UPDATE POSICIONES
            SET PAR_GAN_POS = PARTGANLOC - 1,
                PUNTOS_POS = PUNTLOC - 3,
                GOL_FAV_POS = GOLFAVLOC - GOLEQUILOC,
                GOL_CON_POS = GOLCONLOC - GOLEQUIVIS
            WHERE EQUIPO_POS = LOCAL;
        UPDATE POSICIONES
            SET PAR_PER_POS = PARTPERVIS - 1,
                GOL_FAV_POS = GOLFAVVIS - GOLEQUIVIS,
                GOL_CON_POS = GOLCONVIS - GOLEQUILOC
            WHERE EQUIPO_POS = VISITANTE;
    END IF;

    IF (GOLEQUIVIS > GOLEQUILOC) THEN
        UPDATE POSICIONES
            SET PAR_GAN_POS = PARTGANVIS - 1,
                PUNTOS_POS = PUNTVIS - 3,
                GOL_FAV_POS = GOLFAVVIS - GOLEQUIVIS,
                GOL_CON_POS = GOLCONVIS - GOLEQUILOC
            WHERE EQUIPO_POS = VISITANTE;
        UPDATE POSICIONES
            SET PAR_PER_POS = PARTPERLOC - 1,
                GOL_FAV_POS = GOLFAVLOC - GOLEQUILOC,
                GOL_CON_POS = GOLCONLOC - GOLEQUIVIS
            WHERE EQUIPO_POS = LOCAL;
    END IF;

    IF (GOLEQUILOC = GOLEQUIVIS) THEN
        UPDATE POSICIONES
            SET PAR_EMP_POS = PARTEMPLOC - 1,
                PUNTOS_POS = PUNTLOC - 1,
                GOL_FAV_POS = GOLFAVLOC - GOLEQUILOC,
                GOL_CON_POS = GOLCONLOC - GOLEQUIVIS
            WHERE EQUIPO_POS = LOCAL;
        UPDATE POSICIONES
            SET PAR_EMP_POS = PARTEMPVIS - 1,
                PUNTOS_POS = PUNTVIS - 1,
                GOL_FAV_POS = GOLFAVVIS - GOLEQUIVIS,
                GOL_CON_POS = GOLCONVIS - GOLEQUILOC
            WHERE EQUIPO_POS = VISITANTE;
    END IF;

    SELECT GOL_FAV_POS INTO GOLFAVLOC
    FROM POSICIONES
    WHERE EQUIPO_POS = LOCAL;

    SELECT GOL_FAV_POS INTO GOLFAVVIS
    FROM POSICIONES
    WHERE EQUIPO_POS = VISITANTE;

    SELECT GOL_CON_POS INTO GOLCONLOC
    FROM POSICIONES
    WHERE EQUIPO_POS = LOCAL;

    SELECT GOL_CON_POS INTO GOLCONVIS
    FROM POSICIONES
    WHERE EQUIPO_POS = VISITANTE;

    UPDATE POSICIONES
        SET GOL_FAV_POS = GOLFAVLOC + :NEW.GOL_EQUI_LOC_MAR,
            GOL_CON_POS = GOLCONLOC + :NEW.GOL_EQUI_VIS_MAR
        WHERE EQUIPO_POS = LOCAL;

    UPDATE POSICIONES
        SET GOL_FAV_POS = GOLFAVVIS + :NEW.GOL_EQUI_VIS_MAR,
            GOL_CON_POS = GOLCONVIS + :NEW.GOL_EQUI_LOC_MAR
        WHERE EQUIPO_POS = VISITANTE;

    UPDATE POSICIONES
        SET GOL_DIF_POS = GOL_FAV_POS - GOL_CON_POS
        WHERE EQUIPO_POS = LOCAL;

    UPDATE POSICIONES
        SET GOL_DIF_POS = GOL_FAV_POS - GOL_CON_POS
        WHERE EQUIPO_POS = VISITANTE;

    SELECT PAR_GAN_POS INTO PARTGANLOC
    FROM POSICIONES
    WHERE EQUIPO_POS = LOCAL;

    SELECT PAR_GAN_POS INTO PARTGANVIS
    FROM POSICIONES
    WHERE EQUIPO_POS = VISITANTE;

    SELECT PAR_PER_POS INTO PARTPERLOC
    FROM POSICIONES
    WHERE EQUIPO_POS = LOCAL;

    SELECT PAR_PER_POS INTO PARTPERVIS
    FROM POSICIONES
    WHERE EQUIPO_POS = VISITANTE;

    IF (:NEW.GOL_EQUI_LOC_MAR > :NEW.GOL_EQUI_VIS_MAR) THEN
        UPDATE POSICIONES
            SET PAR_GAN_POS = PARTGANLOC + 1
            WHERE EQUIPO_POS = LOCAL;
        UPDATE POSICIONES
            SET PAR_PER_POS = PARTPERVIS + 1
            WHERE EQUIPO_POS = VISITANTE;
        SELECT PUNTOS_POS INTO PUNTGAN
        FROM POSICIONES
        WHERE EQUIPO_POS = LOCAL;
        UPDATE POSICIONES
            SET PUNTOS_POS = PUNTGAN + 3
            WHERE EQUIPO_POS = LOCAL;
    END IF;

    IF (:NEW.GOL_EQUI_VIS_MAR > :NEW.GOL_EQUI_LOC_MAR) THEN
        UPDATE POSICIONES
            SET PAR_GAN_POS = PARTGANVIS + 1
            WHERE EQUIPO_POS = VISITANTE;
        UPDATE POSICIONES
            SET PAR_PER_POS = PARTPERLOC + 1
            WHERE EQUIPO_POS = LOCAL;
        SELECT PUNTOS_POS INTO PUNTGAN
        FROM POSICIONES
        WHERE EQUIPO_POS = VISITANTE;
        UPDATE POSICIONES
            SET PUNTOS_POS = PUNTGAN + 3
            WHERE EQUIPO_POS = VISITANTE;
    END IF;

    IF (:NEW.GOL_EQUI_LOC_MAR = :NEW.GOL_EQUI_VIS_MAR) THEN
        SELECT PAR_EMP_POS INTO PARTEMPLOC
        FROM POSICIONES
        WHERE EQUIPO_POS = LOCAL;
        SELECT PAR_EMP_POS INTO PARTEMPVIS
        FROM POSICIONES
        WHERE EQUIPO_POS = VISITANTE;
        UPDATE POSICIONES
            SET PAR_EMP_POS = PARTEMPLOC + 1
            WHERE EQUIPO_POS = LOCAL;
        UPDATE POSICIONES
            SET PAR_EMP_POS = PARTEMPVIS + 1
            WHERE EQUIPO_POS = VISITANTE;

        SELECT PUNTOS_POS INTO PUNTEMPLOC
        FROM POSICIONES
        WHERE EQUIPO_POS = LOCAL;
        SELECT PUNTOS_POS INTO PUNTEMPVIS
        FROM POSICIONES
        WHERE EQUIPO_POS = VISITANTE;
        UPDATE POSICIONES
            SET PUNTOS_POS = PUNTEMPLOC + 1
            WHERE EQUIPO_POS = LOCAL;
        UPDATE POSICIONES
            SET PUNTOS_POS = PUNTEMPVIS + 1
            WHERE EQUIPO_POS = VISITANTE;
    END IF;

END UPD_MARCADOR;
.
/

UPDATE MARCADOR
    SET GOL_EQUI_LOC_MAR = 0,
        GOL_EQUI_VIS_MAR = 1
    WHERE NUM_PAR_MAR = 1;

UPDATE MARCADOR
    SET GOL_EQUI_LOC_MAR = 4,
        GOL_EQUI_VIS_MAR = 2
    WHERE NUM_PAR_MAR = 2;

UPDATE MARCADOR
    SET GOL_EQUI_LOC_MAR = 4,
        GOL_EQUI_VIS_MAR = 5
    WHERE NUM_PAR_MAR = 8;

UPDATE MARCADOR
    SET GOL_EQUI_LOC_MAR = 4,
        GOL_EQUI_VIS_MAR = 5
    WHERE NUM_PAR_MAR = 10;