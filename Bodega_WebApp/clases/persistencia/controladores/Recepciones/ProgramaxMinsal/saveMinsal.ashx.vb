Imports System.Web
Imports System.Web.Services
Imports System.Web.Script.Serialization

Public Class saveMinsal
    Implements System.Web.IHttpHandler, System.Web.SessionState.IRequiresSessionState

    Sub ProcessRequest(ByVal context As HttpContext) Implements IHttpHandler.ProcessRequest

        context.Response.ContentType = "application/json"
        Dim cmd As String = context.Request("cmd")
        Dim jsonSerializado As String = "{""status"": ""error"", ""text"":""Se produjo un error en la obtencion de los datos, vuelva a intentarlo mas Tarde. Si el problema persiste comuniquese con informática.""}"

        Select Case cmd
            Case "create-records"
                ' Funcion principal del save grobal.
                jsonSerializado = crearRecepcionProgramaMinsal(context)
        End Select

        context.Response.Write(jsonSerializado)

    End Sub
    'metodo para generar recepcion
    Public Function crearRecepcionProgramaMinsal(ByVal context As HttpContext)

        Dim jsonSerializado As String = ""
        Dim estado As New Dictionary(Of String, String)

        ' Graba Movimiento
        Dim usuario As UsuarioLogeado = context.Session("usuarioLogeado")
        Dim Periodo As String = UCase(context.Request("dataFormMinsal[anioDonacion]"))
        Dim NroDonacionArticulo As String = context.Request("tipoMovimiento")        'TMVNUMERO
        'Dim NroCorrelativo As String = context.Request("dataFormMinsal[numero]")    'No existe sera creado en el procedimiento

        ' Graba Donación
        Dim fechaCompleta As String = context.Request("dataFormMinsal[fechaServidor]")
        Dim descripcion As String = context.Request("dataFormMinsal[descripcion]")
        Dim valor As String = context.Request("valor")
        Dim numeroDoc As String = context.Request("dataFormMinsal[NDocumento]")
        Dim programa As String = context.Request("dataFormMinsal[Nombre_Programa]")

        estado = ControladorPersistencia.saveGeneralMinsal(usuario.username, Periodo, NroDonacionArticulo, fechaCompleta, descripcion,
                                                         valor, numeroDoc, programa)

        If (estado("FLD_CMVNUMERO") <> "0") Then
            jsonSerializado = "{""status"":""success"",""cmvNumero"":" + Trim(estado("FLD_CMVNUMERO")) + "}"
            'jsonSerializado = "{""status"":""succes"",""cmvNumero"":" & Trim(estado("FLD_CMVNUMERO")) & ",""tmvCodigo"":" & Trim(estado("FLD_TMVCODIGO")) & ",""periodo"":" & Trim(estado("FLD_PERCODIGO")) & "}"
        Else
            jsonSerializado = "{""status"":""error"",""message"":""Se presentó un problema en la base de datos vuelva a intentarlo mas tarde, si el problema persiste comuníquese con informática.""}"
        End If

        Return jsonSerializado
    End Function
    ReadOnly Property IsReusable() As Boolean Implements IHttpHandler.IsReusable
        Get
            Return False
        End Get
    End Property

End Class