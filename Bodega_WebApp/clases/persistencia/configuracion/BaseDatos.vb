Imports System.Data.SqlClient

Public Class BaseDatos
    ''' <summary>
    ''' Nombre de usuario
    ''' </summary>
    Private Shared usuario As [String]
    ''' <summary>
    ''' Password de usuario
    ''' </summary>
    Private Shared password As [String]
    ''' <summary>
    ''' Nombre del servidor
    ''' </summary>
    Private Shared servidor As [String]
    ''' <summary>
    ''' Conexión con la base de datos
    ''' </summary>
    Private Shared conexion As SqlConnection
    ''' <summary>
    ''' Lector de salidas de la base de datos
    ''' </summary>
    Private Shared dataReader As SqlDataReader
    ''' <summary>
    ''' Instrucción a la base de datos
    ''' </summary>
    Private Shared comando As SqlCommand
    ''' <summary>
    ''' Parametro procedimiento almacenado
    ''' </summary>
    Private Shared parametro As SqlParameter
    ''' <summary>
    ''' Nombre de la base de datos
    ''' </summary>
    Private Shared baseDatos As [String]
    ''' <summary>
    ''' String de conexión
    ''' </summary>
    Private Shared stringConexion As [String]

    ''' <summary>
    ''' ''Constructor''
    ''' </summary>
    ''' <param name="_usuario">Nombre de usuario</param>
    ''' <param name="_contraseña">Password de usuario</param>
    ''' <param name="_servidor">Nombre del servidor</param>
    ''' <param name="_baseDatos">Nombre de la base de datos</param>
    ''' <returns></returns>
    Public Function conectar(ByVal _usuario As String, ByVal _contrasena As String, ByVal _servidor As String, ByVal _baseDatos As String) As Boolean
        ' If conexion Is Nothing Then
        conexion = New SqlConnection()
        'End If
        Dim sDSN As String
        Dim sConnectU As String
        Dim sConnectP As String
        Dim sADOConnect As String
        usuario = _usuario
        password = _contrasena
        servidor = _servidor
        baseDatos = _baseDatos

        sDSN = "Server=tcp:" & Convert.ToString(servidor) & ";"
        sConnectU = "User Id=" & Convert.ToString(usuario) & ";"
        sConnectP = "Password=" & Convert.ToString(password) & ";"
        sADOConnect = "Database=" & Convert.ToString(baseDatos)

        stringConexion = sDSN & sConnectU & sConnectP & sADOConnect

        Try
            conexion.ConnectionString = (stringConexion)
            conexion.Open()
            conexion.Close()
            Return True
        Catch e As Exception
            conexion.Close()
            Throw e
        End Try
    End Function

    ''' <summary>
    ''' Conectar con base de datos sin parametros.
    ''' </summary>
    Public Sub Conectar_Sin_Datos()
        Try
            If conexion Is Nothing Then
                conexion = New SqlConnection() 'esto es nuevo
                conexion.ConnectionString = stringConexion
            End If

            conexion.Open()
        Catch e As Exception
            conexion.Close()
            Throw New Exception("Error en la base de datos" & vbLf & " Revise innerException para tener mayor detalle", e)
        End Try
    End Sub

    ''' <summary>
    ''' Cierra conexión con la base de datos
    ''' </summary>
    Public Sub cerrar_Conexion()
        conexion.Close()
    End Sub

    ''' <summary>
    ''' Abre conexión con la base de datos
    ''' </summary>
    Public Sub abrir_Conexion()
        Conectar_Sin_Datos()
    End Sub

    ''' <summary>
    ''' Constructor copia
    ''' </summary>
    ''' <param name="connectionString">String de conexión</param>
    Public Sub configure(ByVal connectionString As String)
        conexion = New SqlConnection(connectionString)
        conexion.Open()
        conexion.Close()
    End Sub

    ''' <summary>
    ''' 
    ''' </summary>
    ''' <param name="nombreProcedimiento"></param>
    ''' <returns></returns>
    Public Function crearComando(ByVal nombreProcedimiento As String) As SqlCommand
        comando = New SqlCommand(nombreProcedimiento, conexion)
        comando.CommandType = System.Data.CommandType.StoredProcedure
        Return comando
    End Function
End Class
