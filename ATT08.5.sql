/* Crie uma Trigger denominada dbo.trigger_prevent_assignment_teaches para impedir que aulas sejam atribuidas a um instrutor que já possui 2 ou mais atribuições no ano.*/

CREATE TRIGGER dbo.trigger_prevent_assignment_teaches
ON dbo.teaches
AFTER INSERT, UPDATE -- Dispara após um update ou insert
AS
BEGIN
    SET NOCOUNT ON; -- Evita mostragem de linhas de erro

    IF EXISTS (
        SELECT 1 
        FROM inserted i -- Tabela temporária
        WHERE ( -- Filtro de validação
            SELECT COUNT(*) -- Subquery para contar registros salvos
            FROM dbo.teaches t 
            WHERE t.ID = i.ID
             AND t.year = i.year 
        ) > 2 
    )

    BEGIN -- Início do bloco de erro (mais de 2 atribuições) 
        RAISERROR ('Operação cancelada: Este instrutor já possui 2 tribuições para este ano.');
        ROLLBACK TRANSACTION; -- Desfaz a operação
    	RETURN;
    END
END;