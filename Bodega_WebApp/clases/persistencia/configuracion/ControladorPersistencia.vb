Imports System.Data.SqlClient
Imports System.Web
Imports System.Web.Security
Imports System.Web.UI
Imports System.Web.UI.WebControls
Imports System.Web.UI.WebControls.WebParts
Imports System.Web.UI.HtmlControls

Public Class ControladorPersistencia
    Implements IRequiresSessionState
    Public Shared Function getListaServidores() As List(Of Servidor)
        Return Servidores.Instancia.servidores
    End Function

    Public Shared Function setPersistencia(ByVal usuario As String, ByVal contrasena As String, ByVal idServidor As Integer, httpSessionState As HttpSessionState)
        Dim dataBase As New BaseDatos
        Try
            dataBase.conectar(usuario, contrasena, Servidores.Instancia.getIpServidor(idServidor), ConfigurationManager.AppSettings("baseDatos"))
        Catch e As SqlException
            Dim i As Integer = e.Number
            If i = 18456 Then
                Throw New Exception("Usuario o contraseña incorecta")
            End If
            Throw e
        Catch e As Exception
            Throw e
        End Try
        httpSessionState("baseDatos") = dataBase
        Return ""
    End Function

    Public Shared Function UsuarioValido(ByVal usuario As String) As Boolean
        Dim retorno As String = ""
        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ENTI_CORPORATIVA..MEDNUC_ValidaUsuario")
        comando.Parameters.Add(New SqlParameter("@Usuario", usuario))
        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()
            While lector.Read()
                retorno = Convert.ToString(lector("vigencia"))
            End While
            dataBase.cerrar_Conexion()

            Select Case retorno
                Case "si"
                    Return True
                Case "no"
                    Return False
                Case "no existe"
                    Throw New Exception("En el sistema figura sin usuario. Porfavor contacte a informática para crear su cuenta.")
                Case Else

            End Select
        Catch generatedExceptionName As Exception
            dataBase.cerrar_Conexion()
            Throw New Exception("Error de conexión. Intente más tarde. Si el problema persiste contacté a Informática.")
        End Try
    End Function

    Public Shared Function GetUsuario(ByVal usuario As String) As UsuarioLogeado
        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ENTI_CORPORATIVA..ABANET_PrivilegioUsuario")
        comando.Parameters.Add(New SqlParameter("@Usuario", usuario))
        Try
            Dim nombreUsuario As String = ""
            Dim nombre As String = ""
            Dim rut As String = ""
            Dim tipo As String = ""
            Dim privilegio As String = ""
            Dim centroDeCosto As String = ""
            Dim lector As SqlDataReader = comando.ExecuteReader()
            Dim sinValor As Boolean = True
            While lector.Read()
                nombreUsuario = usuario
                nombre = Convert.ToString(lector("nombre"))
                rut = Convert.ToString(lector("rut"))
                tipo = Convert.ToString(lector("codigoUsuario"))
                '?
                privilegio = Convert.ToString(lector("privilegio"))
                centroDeCosto = Convert.ToString(lector("centroDeCosto"))
                sinValor = False
            End While
            If sinValor Then
                Throw New Exception("No cuenta con los permisos necesarios para ingresar al Sistema de Abastecimiento")
            End If
            dataBase.cerrar_Conexion()
            Dim usuarioConectado As New UsuarioLogeado(nombreUsuario, nombre, rut, tipo, privilegio, centroDeCosto)
            Return usuarioConectado
        Catch e As Exception
            dataBase.cerrar_Conexion()
            Throw e
        End Try
    End Function
    '-----------------------------------------------------
    '  Nuevo - Donación - Extraer lista de bodegas para RecepcionxDonacion
    '-----------------------------------------------------
    Public Shared Function getListaBodegaRecepcionxDonacion(ByVal CentroCosto As String, ByVal establecimiento As String) As ListaBodega

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim listaBodegas As New ListaBodega

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_BODEGAS_CARGACOMBOxCCOSTO")

        comando.Parameters.Add(New SqlParameter("@FLD_ESTCODIGO", establecimiento))
        comando.Parameters.Add(New SqlParameter("@FLD_CCOCODIGO", CentroCosto))

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim value_code As String = Convert.ToString(lector("BODEGAS")).Trim
                'codigo, divide la cadena.
                Dim cadenas As String()
                cadenas = value_code.Split("-")
                listaBodegas.AgregarRecords(cadenas(0), value_code)
                'listaBodegas.AgregarRecords(i, lector("BODEGAS"))
            End While

            dataBase.cerrar_Conexion()
            Return listaBodegas

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '----------------------------------------------------- 
    '-----------------------------------------------------
    '  Nuevo - Donación - Extraer las fechas del form de la RecepcionxDonacion
    '-----------------------------------------------------
    Public Shared Function getListaFechasServidor() As FechasdelaLista

        Dim listafechas As New FechasdelaLista
        Dim dataBase As BaseDatos = getBaseDatos()

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_GEN_TRAEFECHASERVIDOR")

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()
            Dim fechaServer As String = ""
            Dim anioDonacion As String = ""

            While lector.Read()
                fechaServer = lector("Fld_FechaActual")
                anioDonacion = Mid(fechaServer, 7, 4)
            End While

            listafechas.AgregarRecords(fechaServer, anioDonacion)

            dataBase.cerrar_Conexion()
            Return listafechas

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Donación - Retorna el articulo solicitado como donacion
    '-----------------------------------------------------
    Public Shared Function getProductoxSolicitudDeCodigoparaDonacion(ByVal codigo As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_MATERIALES_SEL_net")

        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codigo))

        Dim donacionArticulo As New Dictionary(Of String, String)

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()
            If (lector.Read()) Then
                'While lector.Read()
                donacionArticulo.Add("descripcion", Convert.ToString(lector("Fld_MatNombre")).Trim)
                donacionArticulo.Add("item", Convert.ToString(lector("Fld_IteCodigo")).Trim)
                donacionArticulo.Add("precio", Convert.ToString(lector("Fld_MatPrecio")).Trim)
                'End While
            Else
                donacionArticulo.Add("item", "null")
            End If

            dataBase.cerrar_Conexion()
            Return donacionArticulo

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Donación - Retorna la lista x periodo de donaciones.
    '-----------------------------------------------------
    Public Shared Function getPeriodoDonacion() As ListaBodega

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim listaBodegas As New ListaBodega

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..Pro_tbPeriodoCargaCombo")

        Dim donacionArticulo As New Dictionary(Of String, String)

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()
            Dim i As Integer = 0

            While lector.Read()
                Dim periodo As String = Convert.ToString(lector("Periodos")).Trim
                'fecha, divide la cadena.
                Dim cadenas As String()
                cadenas = periodo.Split(" ")
                listaBodegas.AgregarRecords(cadenas(0), periodo)
                'listaBodegas.AgregarRecords(i, Convert.ToString(lector("Periodos")).Trim)
                i = i + 1
            End While

            dataBase.cerrar_Conexion()
            Return listaBodegas

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Donación - Retorna el historial a la grid 2 de donaciones.
    '-----------------------------------------------------
    Public Shared Function cargaHistorialxFecha(ByVal fecha As String) As historialDonaciones

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim retorno As New historialDonaciones()

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_BUSCAR_DONACIONES_PORAÑO_NEW2014")

        comando.Parameters.Add(New SqlParameter("@FLD_Periodo", fecha))

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()
                retorno.AgregarRecords(i, lector("FLD_CMVNUMERO"), lector("FLD_PERCODIGO"), lector("FLD_DONFECHA"), lector("FLD_DONDESCRIP"))
                i = i + 1
            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Donación - Retorna el historial a la grid 2 de donaciones. buscando con el numero de donación.
    '-----------------------------------------------------
    Public Shared Function cargaHistorialxNDonacion(ByVal NDonacion As String) As historialDonaciones

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim retorno As New historialDonaciones()

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_BUSCAR_DONACIONES_PORNUMERO_NEW2014")

        comando.Parameters.Add(New SqlParameter("@FLD_NDonacion", NDonacion))

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()
            Dim i As Integer = 1

            While lector.Read()
                retorno.AgregarRecords(i, lector("FLD_CMVNUMERO"), lector("FLD_PERCODIGO"), lector("FLD_DONFECHA"), lector("FLD_DONDESCRIP"))
                i = i + 1
            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Donación - Retorna la lista de articulos historicos buscados para imprimir.
    '-----------------------------------------------------
    Public Shared Function getBusquedaDeArticulos(ByVal codigo As String, ByVal periodo As String, ByVal numero As String) As ListaDeArticulosDeHistorial

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim articulos As New ListaDeArticulosDeHistorial

        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DETMOVIMIENTOS_SEL_ORDENCOMPRA_NEW2014")

        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", codigo))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", numero))

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim value_code As String = Convert.ToString(lector("bodega")).Trim
                'codigo, divide la cadena.
                Dim cadenas As String()
                cadenas = value_code.Split("-")
                Dim total As Double

                total = CDbl(lector("total donacion"))

                articulos.AgregarRecords(lector("codigo de material"), Convert.ToString(lector("nombre de material")).Trim, lector("cantidad movida"), lector("unidad de medida"),
                                          lector("neto"), lector("total"), lector("precio unitario"), total,
                                          lector("codigo de item"), cadenas(0), lector("cantidad existente"), lector("Nserie"), lector("fechaVencimiento"))
            End While

            dataBase.cerrar_Conexion()
            Return articulos

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Donación - Obtiene el correlativo para el save.
    '-----------------------------------------------------
    Public Shared Function getCorrelativoDonacion(ByVal fecha As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..pro_GeneraCorrelativoDonacion")

        comando.Parameters.Add(New SqlParameter("@Fld_PerCodigo", fecha))

        Dim donacionArticulo As New Dictionary(Of String, String)

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            If (lector.Read()) Then
                donacionArticulo.Add("Correlativo", Convert.ToString(lector("Correlativo")).Trim)
            Else
                donacionArticulo.Add("item", "null")
            End If

            dataBase.cerrar_Conexion()
            Return donacionArticulo

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Donación - Graba el movimiento.
    '-----------------------------------------------------
    Public Shared Function saveMovimiento(ByVal fecha As String, ByVal NumeroDonacionArticulo As String, ByVal NumeroCorrelativo As String, ByVal usuario As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_COMMOVIMIENTO_INS")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))
        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", NumeroDonacionArticulo))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", NumeroCorrelativo))
        comando.Parameters.Add(New SqlParameter("@FLD_USULOGIN", usuario))

        Dim lector As SqlDataReader = comando.ExecuteReader()
        dataBase.cerrar_Conexion()

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Donación - Graba el detalle del movimiento.
    '-----------------------------------------------------
    Public Shared Function saveDetalleMovimiento(ByVal cont As String, ByVal NumeroDonacionArticulo As String, ByVal fecha As String, ByVal NumeroCorrelativo As String,
                                                 ByVal CantidadMovimiento As Single, ByVal dbodega As String, ByVal CodigoMaterial As String, ByVal ItemMaterial As String,
                                                 ByVal null As Single, ByVal null2 As Single, ByVal null3 As Single, ByVal PrecioUnitario As Single,
                                                 ByVal loteSerie As String, ByVal fechaVencimiento As DateTime)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DETMOVIMIENTOS_INS_RECEPCION_DONACION_NEW2014")

        comando.Parameters.Add(New SqlParameter("@FLD_MOVNUMEROLINEA", cont))
        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", NumeroDonacionArticulo))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", NumeroCorrelativo))
        comando.Parameters.Add(New SqlParameter("@FLD_MOVCANTIDAD", CantidadMovimiento))
        comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", dbodega))
        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", CodigoMaterial))
        comando.Parameters.Add(New SqlParameter("@FLD_ITECODIGO", ItemMaterial))
        comando.Parameters.Add(New SqlParameter("@FLD_CANTPEDIDA", null))
        comando.Parameters.Add(New SqlParameter("@FLD_CANTADEVOLVER", null2))
        comando.Parameters.Add(New SqlParameter("@FLD_CANTPENDIENTE", null3))
        comando.Parameters.Add(New SqlParameter("@FLD_PRECIOUNITARIO", PrecioUnitario))
        comando.Parameters.Add(New SqlParameter("@FLD_SERIELOTE", loteSerie))
        comando.Parameters.Add(New SqlParameter("@FLD_FECHAVENCIMIENTO", fechaVencimiento))


        Dim lector As SqlDataReader = comando.ExecuteReader()
        dataBase.cerrar_Conexion()

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Donación - Graba la donación.
    '-----------------------------------------------------
    Public Shared Function saveDonacion(ByVal fecha As String, ByVal NumeroDonacionArticulo As String, ByVal Ncorrelativo As Integer, ByVal fechaCompleta As DateTime,
                                                 ByVal descripcion As String, ByVal valor As Single, ByVal numeroDoc As Integer)


        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DONACIONES_INS")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))
        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", NumeroDonacionArticulo))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", Ncorrelativo))
        comando.Parameters.Add(New SqlParameter("@FLD_DONFECHA", fechaCompleta))
        comando.Parameters.Add(New SqlParameter("@FLD_DONDESCRIP", descripcion))
        comando.Parameters.Add(New SqlParameter("@FLD_MOVPRECIO", valor))
        comando.Parameters.Add(New SqlParameter("@FLD_NRODOC", numeroDoc))

        Dim lector As SqlDataReader = comando.ExecuteReader()
        dataBase.cerrar_Conexion()

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Donación - Save General - new OCT 2015
    '-----------------------------------------------------
    Public Shared Function saveGeneralDonacion(ByVal usuario As String, ByVal periodo As String, ByVal tipoMovimiento As String,
                                             ByVal fechaCompleta As DateTime, ByVal descripcion As String, ByVal valor As String, ByVal numeroDoc As Double)

        Dim respuesta As New Dictionary(Of String, String)
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_RECEPCION_DONACION_INS_ALL_new2015")

            comando.Parameters.Add(New SqlParameter("@FLD_USULOGIN", usuario))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", tipoMovimiento))
            comando.Parameters.Add(New SqlParameter("@FLD_DONFECHA", fechaCompleta))
            comando.Parameters.Add(New SqlParameter("@FLD_DONDESCRIP", descripcion))
            comando.Parameters.Add(New SqlParameter("@FLD_MOVPRECIO", valor))
            comando.Parameters.Add(New SqlParameter("@FLD_NRODOC", numeroDoc))

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                respuesta.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                respuesta.Add("FLD_TMVCODIGO", Convert.ToString(lector("FLD_TMVCODIGO")))
                respuesta.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                respuesta.Add("ERROR", Convert.ToString(lector("ERROR")))

            End While

            dataBase.cerrar_Conexion()

            Return respuesta

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            respuesta.Add("FLD_CMVNUMERO", "0")
            respuesta.Add("FLD_TMVCODIGO", "0")
            respuesta.Add("FLD_PERCODIGO", "0")
            respuesta.Add("ERROR", ex.Message)
            Return respuesta

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Donación - Retorna la informacion de materiales segun el interes de busqueda.
    '-----------------------------------------------------
    Public Shared Function BuscarInfo_Materiales_RecepxDonacion(ByVal NombreMat As String) As ListadeInfoMateriales_RecepxDonacion

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim retorno As New ListadeInfoMateriales_RecepxDonacion()

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_BUSCA_MATERIALES_ALL")

        comando.Parameters.Add(New SqlParameter("@FLD_MATNOMBRE", NombreMat))

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()
                retorno.AgregarRecords(i, lector("FLD_MATCODIGO"), Convert.ToString(lector("FLD_MATNOMBRE").Trim), lector("FLD_EXIPRECIOUNITARIO"), Convert.ToString(lector("FLD_ITECODIGO").Trim))
                i = i + 1
            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------------------------------
    '  Nuevo - MINSAL - Extraer lista de programas para Recepcion x Programa Ministerial
    '-----------------------------------------------------------------------------
    Public Shared Function getListaProgramasxMinsal() As ListaProgramas

        Dim listaProgramas As New ListaProgramas


        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_PROGRAMAS_CARGACOMBO")

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim value_code As String = Convert.ToString(lector("Programas")).Trim
                'programa es dividido y se extrae el codigo de programa.
                Dim cadenas As String()
                cadenas = value_code.Split("-")

                listaProgramas.AgregarRecords(cadenas(0), value_code)

            End While

            dataBase.cerrar_Conexion()
            Return listaProgramas

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------------------
    '  Nuevo - MINSAL - Retorna el historial de donaciones a la grid 2 del Programa Minsal, Busqueda por numero
    '-----------------------------------------------------------------
    Public Shared Function cargaHistorialxNumero_ProgramaMinsal(ByVal NDonacion As String) As historialDonacionesProgramaMinsal


        Dim dataBase As BaseDatos = getBaseDatos()
        Dim retorno As New historialDonacionesProgramaMinsal()

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_RECEPCIONES_MINSAL_SEL_PORNUMERO_NEW2014")

        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", NDonacion))

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()
            Dim i As Integer = 1

            While lector.Read()

                Dim value_code As String = Convert.ToString(lector("Programa")).Trim
                'programa es dividido y se extrae el codigo de programa.
                Dim cadenas As String()
                cadenas = value_code.Split("-")

                retorno.AgregarRecords(i, lector("FLD_PERCODIGO"), lector("FLD_CMVNUMERO"), lector("Fld_Minfecha"), lector("Fld_NroDoc"), lector("Fld_MinDescrip"), lector("Fld_MovPrecio"), cadenas(0))
                i = i + 1

            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - MINSAL - Retorna el historial a la grid 2 de donaciones.
    '-----------------------------------------------------
    Public Shared Function cargaHistorialxFecha_ProgramaMinsal(ByVal fecha As String) As historialDonacionesProgramaMinsal

        Dim retorno As New historialDonacionesProgramaMinsal()

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_RECEPCIONES_MINSAL_SEL_PORFECHA_NEW2014")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim value_code As String = Convert.ToString(lector("Programa")).Trim
                'programa es dividido y se extrae el codigo de programa.
                Dim cadenas As String()
                cadenas = value_code.Split("-")

                retorno.AgregarRecords(i, lector("FLD_PERCODIGO"), lector("FLD_CMVNUMERO"), lector("Fld_Minfecha"), lector("Fld_NroDoc"), lector("Fld_MinDescrip"), lector("Fld_MovPrecio"), cadenas(0))
                i = i + 1

            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - MINSAL - Save General - new OCT 2015
    '-----------------------------------------------------
    Public Shared Function saveGeneralMinsal(ByVal usuario As String, ByVal periodo As String, ByVal tipoMovimiento As String,
                                             ByVal fechaCompleta As DateTime, ByVal descripcion As String, ByVal valor As String,
                                             ByVal numeroDoc As Double, ByVal programa As String)

        Dim respuesta As New Dictionary(Of String, String)
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_RECEPCION_MINSAL_INS_ALL_new2015")

            comando.Parameters.Add(New SqlParameter("@FLD_USULOGIN", usuario))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", tipoMovimiento))
            comando.Parameters.Add(New SqlParameter("@FLD_DONFECHA", fechaCompleta))
            comando.Parameters.Add(New SqlParameter("@FLD_DONDESCRIP", descripcion))
            comando.Parameters.Add(New SqlParameter("@FLD_MOVPRECIO", valor))
            comando.Parameters.Add(New SqlParameter("@FLD_NRODOC", numeroDoc))
            comando.Parameters.Add(New SqlParameter("@FLD_CODPROGRAMA", programa))

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                respuesta.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                respuesta.Add("FLD_TMVCODIGO", Convert.ToString(lector("FLD_TMVCODIGO")))
                respuesta.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                respuesta.Add("ERROR", Convert.ToString(lector("ERROR")))

            End While

            dataBase.cerrar_Conexion()

            Return respuesta

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            respuesta.Add("FLD_CMVNUMERO", "0")
            respuesta.Add("FLD_TMVCODIGO", "0")
            respuesta.Add("FLD_PERCODIGO", "0")
            respuesta.Add("ERROR", ex.Message)
            Return respuesta

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - MINSAL - Obtiene el correlativo para el save.
    '-----------------------------------------------------
    Public Shared Function getCorretativoMinsal(ByVal fecha As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..pro_GeneraCorrelativoProgramaMinsal")

        comando.Parameters.Add(New SqlParameter("@Fld_PerCodigo", fecha))

        Dim donacionArticulo As New Dictionary(Of String, String)

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            If (lector.Read()) Then
                donacionArticulo.Add("Correlativo", Convert.ToString(lector("Correlativo")).Trim)
            Else
                donacionArticulo.Add("item", "null")
            End If

            dataBase.cerrar_Conexion()
            Return donacionArticulo

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Minsal - Graba el movimiento.
    '-----------------------------------------------------
    Public Shared Function saveMovimientoMinsal(ByVal fecha As String, ByVal NumeroDonacionArticulo As String, ByVal NumeroCorrelativo As Integer, ByVal usuario As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_COMMOVIMIENTO_INS")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))
        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", NumeroDonacionArticulo))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", NumeroCorrelativo))
        comando.Parameters.Add(New SqlParameter("@FLD_USULOGIN", usuario))

        Dim lector As SqlDataReader = comando.ExecuteReader()
        dataBase.cerrar_Conexion()

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Minsal - Graba el detalle del movimiento.
    '-----------------------------------------------------
    Public Shared Function saveDetalleMovimientoMinsal(ByVal cont As String, ByVal CodigoProgramaMinsal As String, ByVal fecha As String, ByVal NumeroCorrelativo As String,
                                                 ByVal CantidadMovimiento As Single, ByVal dbodega As String, ByVal CodigoMaterial As String, ByVal ItemMaterial As String,
                                                 ByVal null As Single, ByVal null2 As Single, ByVal null3 As Single, ByVal PrecioUnitario As Single,
                                                 ByVal loteSerie As String, ByVal fechaVencimiento As DateTime)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DETMOVIMIENTOS_INS_RECEPCION_DONACION_NEW2014")

        comando.Parameters.Add(New SqlParameter("@FLD_MOVNUMEROLINEA", cont))
        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", CodigoProgramaMinsal))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", NumeroCorrelativo))
        comando.Parameters.Add(New SqlParameter("@FLD_MOVCANTIDAD", CantidadMovimiento))
        comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", dbodega))
        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", CodigoMaterial))
        comando.Parameters.Add(New SqlParameter("@FLD_ITECODIGO", ItemMaterial))
        comando.Parameters.Add(New SqlParameter("@FLD_CANTPEDIDA", null))
        comando.Parameters.Add(New SqlParameter("@FLD_CANTADEVOLVER", null2))
        comando.Parameters.Add(New SqlParameter("@FLD_CANTPENDIENTE", null3))
        comando.Parameters.Add(New SqlParameter("@FLD_PRECIOUNITARIO", PrecioUnitario))
        comando.Parameters.Add(New SqlParameter("@FLD_SERIELOTE", loteSerie))
        comando.Parameters.Add(New SqlParameter("@FLD_FECHAVENCIMIENTO", fechaVencimiento))

        Dim lector As SqlDataReader = comando.ExecuteReader()
        dataBase.cerrar_Conexion()

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Minsal - Graba la donación.
    '-----------------------------------------------------
    Public Shared Function saveDonacionMinsal(ByVal fecha As String, ByVal NumeroDonacionArticulo As String, ByVal Ncorrelativo As Integer, ByVal fechaCompleta As DateTime,
                                                 ByVal descripcion As String, ByVal valor As Single, ByVal numeroDoc As Integer, ByVal programa As String)


        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_PROGRAMASMINSAL_INS")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))
        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", NumeroDonacionArticulo))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", Ncorrelativo))
        comando.Parameters.Add(New SqlParameter("@FLD_DONFECHA", fechaCompleta))
        comando.Parameters.Add(New SqlParameter("@FLD_DONDESCRIP", descripcion))
        comando.Parameters.Add(New SqlParameter("@FLD_MOVPRECIO", valor))
        comando.Parameters.Add(New SqlParameter("@FLD_NRODOC", numeroDoc))
        comando.Parameters.Add(New SqlParameter("@FLD_CODPROGRAMA", programa))

        Dim lector As SqlDataReader = comando.ExecuteReader()
        dataBase.cerrar_Conexion()

    End Function
    '-------------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Recepción - DevolucionxPrestamos - Retorna el historial a la grid 2 
    '          de prestamos,busqueda por Fecha.
    '-----------------------------------------------------
    Public Shared Function cargaHistorialxFecha_DevoxPrestamo(ByVal fecha As String) As ListaGrid2HistoricoxPrestamo

        Dim retorno As New ListaGrid2HistoricoxPrestamo()

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_PRESTAMOS_PORFECHA_NEW2014")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                retorno.AgregarRecords(i, lector("FLD_PERCODIGO"), lector("FLD_CMVNUMERO"), lector("FLD_PREFECHA"), lector("FLD_PREDESCRIPCION"))
                i = i + 1

            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Recepción - DevolucionxPrestamos - Retorna el historial a la grid 2 
    '          de prestamos, busqueda por Numero de prestamo.
    '-----------------------------------------------------
    Public Shared Function cargaHistorialxNPrestamo_DevoxPrestamo(ByVal NPrestamo As String) As ListaGrid2HistoricoxPrestamo

        Dim retorno As New ListaGrid2HistoricoxPrestamo()

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_PRESTAMOS_PORNUMERO_NEW2014")

        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", NPrestamo))

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                retorno.AgregarRecords(i, lector("FLD_PERCODIGO"), lector("FLD_CMVNUMERO"), lector("FLD_PREFECHA"), lector("FLD_PREDESCRIPCION"))
                i = i + 1

            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Recepción - DevolucionxPrestamos - Extraer las fechas para el form
    '-----------------------------------------------------
    Public Shared Function getListaFechasServidor_DevoXPrestamo() As FechaGrid_DevoXPrestamo

        Dim listafechas As New FechaGrid_DevoXPrestamo
        Dim dataBase As BaseDatos = getBaseDatos()

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_GEN_TRAEFECHASERVIDOR")

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()
            Dim fechaServer As String = ""
            Dim anioDonacion As String = ""

            While lector.Read()
                fechaServer = lector("Fld_FechaActual")
                anioDonacion = Mid(fechaServer, 7, 4)
            End While

            listafechas.AgregarRecords(fechaServer, anioDonacion)

            dataBase.cerrar_Conexion()
            Return listafechas

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '---------------------------------------------------------------
    '  Nuevo - Recepción - DevolucionxPrestamos - Retorna el historial de datos para grid 1, Nuevo
    '---------------------------------------------------------------
    Public Shared Function cargaHistorial_Grid1_DevoxPrestamo(ByVal Nprestamo As Integer, ByVal fecha As String) As ListaDevoPrestamo

        Dim retorno As New ListaDevoPrestamo()

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        '                                                [PRO_DETALLE_DESPACHOxPRESTAMOS_PORAÑO_NEW2014] FAIL
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_DETALLE_DESPACHOxPRESTAMO_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", Nprestamo))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                retorno.AgregarRecords(i, Convert.ToString(lector("codigo de material")).Trim,
                                       Convert.ToString(lector("nombre de material")).Trim,
                                       Convert.ToString(lector("codigo de item")).Trim,
                                       "",
                                       Convert.ToString(lector("bodega")).Trim,
                                       "",
                                       lector("cantidad movida"),
                                       0,
                                       lector("precio unitario"),
                                       lector("cantidad Devolver"),
                                       0)
                i = i + 1

            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Recepción - DevolucionxPrestamos - Obtiene el correlativo para el save.
    '-----------------------------------------------------
    Public Shared Function getCorrelativoRecepDevoxPrestamo(ByVal fecha As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..pro_GeneraCorrelativo_DevolucionxPrestamo_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))

        Dim donacionArticulo As New Dictionary(Of String, String)

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            If (lector.Read()) Then
                donacionArticulo.Add("Correlativo", Convert.ToString(lector("Correlativo")).Trim)
            Else
                donacionArticulo.Add("item", "null")
            End If

            dataBase.cerrar_Conexion()
            Return donacionArticulo

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '---------------------------------------------------------------
    '  Nuevo - Recepción - DevolucionxPrestamos - Retorna el historial de datos para grid 1, Antiguo
    '---------------------------------------------------------------
    Public Shared Function cargaHistorial_Grid1_DevoxPrestamo_Antiguo(ByVal Nprestamo As Integer, ByVal fecha As String) As ListaDevoPrestamoAntiguo

        Dim retorno As New ListaDevoPrestamoAntiguo()

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        '                                                [PRO_DETALLE_DESPACHOxPRESTAMOS_PORAÑO_NEW2014] FAIL
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_DETALLE_DESPACHOxPRESTAMO")

        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", Nprestamo))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                retorno.AgregarRecords(i, Convert.ToString(lector("FLD_MATCODIGO")).Trim, Convert.ToString(lector("FLD_MATNOMBRE")).Trim, Convert.ToString(lector("FLD_ITECODIGO")).Trim,
                                       Convert.ToString(lector("FLD_ITEDENOMINACION")).Trim, Convert.ToString(lector("FLD_BODCODIGO")).Trim,
                                       Convert.ToString(lector("FLD_BODNOMBRES")).Trim, lector("FLD_MOVCANTIDAD"), lector("CNT_DEVOLVER"), lector("FLD_PRECIOUNITARIO"))
                i = i + 1

            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Recepción - DevolucionxPrestamos - Graba el detalle del movimiento, para cada articulo en la tabla TEMP.
    '-----------------------------------------------------
    Public Shared Function saveDetalleMovimiento_DevoluxPrestamo_Temp(ByVal cont As String, ByVal NumeroDonacionArticulo As String, ByVal fecha As String,
                                                                      ByVal NumeroCorrelativo As String, ByVal CantidadMovimientoG As Integer, ByVal CantidadMovimientoD As Integer,
                                                                      ByVal CodigoMaterial As String, ByVal NSerie As String, ByVal FechaVto As DateTime,
                                                                      ByVal CodBodega As String, ByVal ItemArticulo As String, ByVal PrecioUni As Single)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DETMOVIMIENTOS_INS_DETALLE_TEMP_DEVOLUxPRESTAMO_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_MOVNUMEROLINEA", cont))
        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", NumeroDonacionArticulo))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", NumeroCorrelativo))
        comando.Parameters.Add(New SqlParameter("@FLD_MOVCANTIDAD_GENERAL", CantidadMovimientoG))
        comando.Parameters.Add(New SqlParameter("@FLD_MOVCANTIDAD_DETALLE", CantidadMovimientoD))
        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", CodigoMaterial))
        comando.Parameters.Add(New SqlParameter("@FLD_NSERIE", NSerie))
        comando.Parameters.Add(New SqlParameter("@FLD_FECHAVENCIMIENTO", FechaVto))
        comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", CodBodega))
        comando.Parameters.Add(New SqlParameter("@FLD_ITECODIGO", ItemArticulo))
        comando.Parameters.Add(New SqlParameter("@FLD_PRECIOUNITARIO", PrecioUni))


        Dim lector As SqlDataReader = comando.ExecuteReader()
        dataBase.cerrar_Conexion()

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Recepción - DevolucionxPrestamos - Obtiene el correlativo para el save.
    '-----------------------------------------------------
    Public Shared Function BuscaCorrelativoRecep_DevolucionxPrestamo(ByVal fecha As String, ByVal Ncorrelativo As Integer, ByVal CodMaterial As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..pro_Busca_Correlativo_DevolucionXPrestamo_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", Ncorrelativo))
        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", CodMaterial))

        Dim donacionArticulo As New Dictionary(Of String, String)

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            If (lector.Read()) Then
                donacionArticulo.Add("Tabla", Convert.ToString(lector("Tabla")).Trim)
            Else
                donacionArticulo.Add("item", "null")
            End If

            dataBase.cerrar_Conexion()
            Return donacionArticulo

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Recepción - DevolucionxPrestamos - Retorna Historico de los detalles de los articulos buscando por codigo, bodega y correlativo. Tabla 2
    '-----------------------------------------------------
    Public Shared Function getHistorial_DetalleTempRecep_DevoxPrestamo(ByVal codigo As String, ByVal bodega As String, ByVal correlativo As Integer) As ListaDetalleArticulos_DevolucionxPrestamo

        Dim retorno As New ListaDetalleArticulos_DevolucionxPrestamo()

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_BUSCATEMP_DETALLE_MATERIALES_HISTORICO_DevolxPrestamo_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codigo))
        'comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", bodega))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", correlativo))

        Dim donacionArticulo As New Dictionary(Of String, String)

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                retorno.AgregarRecords(i, Convert.ToString(lector("FLD_MOVNUMEROLINEA")).Trim, Convert.ToString(lector("FLD_TMVCODIGO")).Trim,
                                       lector("FLD_PERCODIGO"), lector("FLD_CMVNUMERO"), Convert.ToString(lector("FLD_MATCODIGO")).Trim, lector("FLD_MOVCANTIDAD_DETALLE"),
                                       Convert.ToString(lector("FLD_NSERIE")).Trim, lector("FLD_FECHAVENCIMIENTO"), Convert.ToString(lector("FLD_BODCODIGO")).Trim)
                i = i + 1

            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Recepción - DevolucionxPrestamos - Retorna Historico de los detalles de los articulos buscando por codigo, bodega y correlativo. Tabla 1
    '-----------------------------------------------------
    Public Shared Function getHistorial_DetalleTabla1Recep_DevoxPrestamo(ByVal codigo As String, ByVal bodega As String, ByVal correlativoPrestamo As Integer, ByVal anioPrestamo As String) As ListaDetalleArticulos

        Dim retorno As New ListaDetalleArticulos()

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_BUSCATEMP_DETALLE_MATERIALES_DevolxPrestamo_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codigo))
        comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", bodega))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO_ANTIGUO", correlativoPrestamo))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", anioPrestamo))

        Dim donacionArticulo As New Dictionary(Of String, String)

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                retorno.AgregarRecords(i, Convert.ToString(lector("FLD_MOVNUMEROLINEA")).Trim, Convert.ToString(lector("FLD_TMVCODIGO")).Trim,
                                       lector("FLD_PERCODIGO"), lector("FLD_CMVNUMERO"), Convert.ToString(lector("FLD_MATCODIGO")).Trim, lector("FLD_MOVCANTIDAD"),
                                       Convert.ToString(lector("FLD_NSERIE")).Trim, lector("FLD_FECHAVENCIMIENTO"))
                i = i + 1

            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Recepción - DevolucionxPrestamos - Graba el movimiento.
    '-----------------------------------------------------
    Public Shared Function saveMovimiento_DevoluxPrestamo(ByVal CodigoTrasaccion As String, ByVal fechaPrestamo As String, ByVal NcorrelativoNuevo As String,
                                                          ByVal fechaCompleta As DateTime, ByVal usuario As String, ByVal descripcion As String,
                                                          ByVal CodigoTrasaccionAnterior_Prestamo As String, ByVal fechaDonacion As String, ByVal NcorrelativoAntiguo_Prestamo As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DEVOLUCIONESxPRESTAMOS_INS_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", CodigoTrasaccion))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fechaPrestamo))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", NcorrelativoNuevo))
        comando.Parameters.Add(New SqlParameter("@FLD_DEVFECHA", fechaCompleta))
        comando.Parameters.Add(New SqlParameter("@FLD_USULOGIN", usuario))
        comando.Parameters.Add(New SqlParameter("@FLD_DEVDESCRIPCION", descripcion))
        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO_PRE", CodigoTrasaccionAnterior_Prestamo))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO_PRE", fechaDonacion))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO_PRE", NcorrelativoAntiguo_Prestamo))

        Dim lector As SqlDataReader = comando.ExecuteReader()
        dataBase.cerrar_Conexion()

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Recepción - DevolucionxPrestamos - Graba el detalle del movimiento.
    '-----------------------------------------------------
    Public Shared Function saveDetalleMovimiento_DevoluxPrestamo(ByVal fechaNueva As String, ByVal NCorrelativoNuevo As String,
                                                                 ByVal CodigoTrasaccionNuevo As String, ByVal fechaAntiguo As String,
                                                                 ByVal NCorrelativoAntiguo As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DEVOLUCIONESxPRESTAMO_DET_INS_DETALLES_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO_NUEVO", fechaNueva))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO_NUEVO", NCorrelativoNuevo))
        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO_NUEVO", CodigoTrasaccionNuevo))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO_ANTIGUO", fechaAntiguo))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO_ANTIGUO", NCorrelativoAntiguo))

        Dim lector As SqlDataReader = comando.ExecuteReader()
        dataBase.cerrar_Conexion()

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Recepción - DevolucionxPrestamos - Obtiene El encabezado de los datos guardados de la devolucion efectuada.
    '-----------------------------------------------------
    Public Shared Function getDatos_EncabezadoHistotico_DevoxPrestamo(ByVal CodigoTrasaccionNuevo As String, ByVal CodigoTrasaccionAntiguo As String,
                                                                      ByVal fechaPrestamo As String, ByVal NcorrelativoAntiguo_Prestamo As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DEVOLUCIONESxPRESTAMO_ENCABEZADO_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO_NUEVO", CodigoTrasaccionNuevo))
        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO_ANTIGUO", CodigoTrasaccionAntiguo))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fechaPrestamo))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO_ANTIGUO", NcorrelativoAntiguo_Prestamo))

        Dim EncabezadoDevolucion As New Dictionary(Of String, String)
        Dim anioDonacion As String = ""
        Dim fechaServer As String = ""

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            If (lector.Read()) Then
                EncabezadoDevolucion.Add("NDevolucion", Convert.ToString(lector("NDevolucion")).Trim)
                EncabezadoDevolucion.Add("Descripcion", Convert.ToString(lector("Descripcion")).Trim)
                EncabezadoDevolucion.Add("fechaDev", Convert.ToString(lector("fechaDev")).Trim)
                fechaServer = Convert.ToString(lector("fechaDev")).Trim
                anioDonacion = Mid(fechaServer, 7, 4)
                EncabezadoDevolucion.Add("anioDEV", anioDonacion)
                EncabezadoDevolucion.Add("fechaPrestamo", Convert.ToString(lector("fechaPrestamo")).Trim)

            Else
                EncabezadoDevolucion.Add("item", "null")
            End If

            dataBase.cerrar_Conexion()
            Return EncabezadoDevolucion

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-------------------------------------------------------------
    '  Nuevo - RecepcionxSolicitudPrestamo - Extraer lista de Instituciones.
    '-------------------------------------------------------------
    Public Shared Function getListaInstitucionesRecepcionxPrestamo() As ListaInstituciones

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim listaInstituciones As New ListaInstituciones

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_INSTITUCION_CARGACOMBO")

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim value_code As String = Convert.ToString(lector("Instituciones")).Trim
                'codigo, divide la cadena.
                Dim cadenas As String()
                cadenas = value_code.Split("-")
                listaInstituciones.AgregarRecords(cadenas(0), value_code)
            End While

            dataBase.cerrar_Conexion()
            Return listaInstituciones

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - RecepcionxSolicitudPrestamo - Retorna el historial a la grid 2.
    '-----------------------------------------------------
    Public Shared Function cargaHistorialxFechaRecepcionxSolicitudPrestamo(ByVal fecha As String) As HistorialDonacionesRecepXSolicitudPrestamo

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim retorno As New HistorialDonacionesRecepXSolicitudPrestamo()

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_RECEPCIONXPRESTAMOS_SEL_PORAÑO_NEW2014")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()
                retorno.AgregarRecords(i, lector("FLD_CMVNUMERO"), lector("FLD_PERCODIGO"), lector("Fld_Prefecha"), lector("Fld_NroDoc"), lector("Fld_PreDescripcion"), lector("Fld_MovPrecio"), lector("Instituto"))
                i = i + 1
            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - RecepcionxSolicitudPrestamo - Retorna el historial a la grid 2.
    '-----------------------------------------------------
    Public Shared Function cargaHistorialxNumeroRecepcionxSolicitudPrestamo(ByVal numero As String) As HistorialDonacionesRecepXSolicitudPrestamo

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim retorno As New HistorialDonacionesRecepXSolicitudPrestamo()

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_RECEPCIONXPRESTAMOS_SEL_PORNUMERO_NEW2014")

        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", numero))

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim value_code As String = Convert.ToString(lector("Instituto")).Trim
                'codigo, divide la cadena.
                Dim cadenas As String()
                cadenas = value_code.Split("-")
                retorno.AgregarRecords(i, lector("FLD_CMVNUMERO"), lector("FLD_PERCODIGO"), lector("Fld_Prefecha"), lector("Fld_NroDoc"), lector("Fld_PreDescripcion"), lector("Fld_MovPrecio"), cadenas(0))
                i = i + 1
            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - RecepcionxSolicitudPrestamo - Obtiene el correlativo para el save.
    '-----------------------------------------------------
    Public Shared Function getCorrelativoRecepxSolicitudPrestamo(ByVal fecha As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..pro_GeneraCorrelativorRecepcionXPrestamo")

        comando.Parameters.Add(New SqlParameter("@Fld_PerCodigo", fecha))

        Dim donacionArticulo As New Dictionary(Of String, String)

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            If (lector.Read()) Then
                donacionArticulo.Add("Correlativo", Convert.ToString(lector("Correlativo")).Trim)
            Else
                donacionArticulo.Add("item", "null")
            End If

            dataBase.cerrar_Conexion()
            Return donacionArticulo

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - RecepcionxSolicitudPrestamo - Save General - new OCT 2015
    '-----------------------------------------------------
    Public Shared Function saveSolicitudDePrestamo(ByVal usuario As String, ByVal periodo As String, ByVal tipoMovimiento As String,
                                             ByVal fechaCompleta As DateTime, ByVal descripcion As String, ByVal valor As String,
                                             ByVal numeroDoc As Double, ByVal Institucion As String)

        Dim respuesta As New Dictionary(Of String, String)
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_RECEPCION_SOLIPRESTAMO_INS_ALL_new2015")

            comando.Parameters.Add(New SqlParameter("@FLD_USULOGIN", usuario))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", tipoMovimiento))
            comando.Parameters.Add(New SqlParameter("@FLD_PREFECHA", fechaCompleta))
            comando.Parameters.Add(New SqlParameter("@FLD_PREDESCRIP", descripcion))
            comando.Parameters.Add(New SqlParameter("@FLD_MOVPRECIO", valor))
            comando.Parameters.Add(New SqlParameter("@FLD_NRODOC", numeroDoc))
            comando.Parameters.Add(New SqlParameter("@FLD_CODINSTITUTO", Institucion))

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                respuesta.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                respuesta.Add("FLD_TMVCODIGO", Convert.ToString(lector("FLD_TMVCODIGO")))
                respuesta.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                respuesta.Add("ERROR", Convert.ToString(lector("ERROR")))

            End While

            dataBase.cerrar_Conexion()

            Return respuesta

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            respuesta.Add("FLD_CMVNUMERO", "0")
            respuesta.Add("FLD_TMVCODIGO", "0")
            respuesta.Add("FLD_PERCODIGO", "0")
            respuesta.Add("ERROR", ex.Message)
            Return respuesta

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - RecepcionxSolicitudPrestamo - Graba el Préstamo.
    '-----------------------------------------------------
    Public Shared Function saveDonacionRecepxSolicitudPrestamo(ByVal fecha As String, ByVal NumeroDonacionArticulo As String, ByVal Ncorrelativo As Integer, ByVal fechaCompleta As DateTime,
                                                 ByVal descripcion As String, ByVal valor As Single, ByVal numeroDoc As Integer, ByVal codInstitucion As String)


        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_RECEPCIONXPRESTAMOS")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))
        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", NumeroDonacionArticulo))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", Ncorrelativo))
        comando.Parameters.Add(New SqlParameter("@FLD_PREFECHA", fechaCompleta))
        comando.Parameters.Add(New SqlParameter("@FLD_PREDESCRIP ", descripcion))
        comando.Parameters.Add(New SqlParameter("@FLD_MOVPRECIO", valor))
        comando.Parameters.Add(New SqlParameter("@FLD_NRODOC", numeroDoc))
        comando.Parameters.Add(New SqlParameter("@FLD_CODINSTITUTO", codInstitucion))

        Dim lector As SqlDataReader = comando.ExecuteReader()
        dataBase.cerrar_Conexion()

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - RecepcionxSolicitudPrestamo - Retorna el articulo buscado por codigo.
    '-----------------------------------------------------
    Public Shared Function getProductoxCodigoparaRecepxSoliPrestamo(ByVal codigo As String, ByVal bodega As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..Pro_tbBuscarMaterialesXCodigo_Exs")

        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codigo))
        comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", bodega))

        Dim donacionArticulo As New Dictionary(Of String, String)

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()
            If (lector.Read()) Then
                donacionArticulo.Add("descripcion", Convert.ToString(lector("FLD_MATNOMBRE")).Trim)
                donacionArticulo.Add("item", Convert.ToString(lector("FLD_ITECODIGO")).Trim)
                donacionArticulo.Add("precio", lector("FLD_EXIPRECIOUNITARIO"))
                donacionArticulo.Add("existencia", Convert.ToString(lector("FLD_EXICANTIDAD")).Trim)
            Else
                donacionArticulo.Add("item", "null")
            End If

            dataBase.cerrar_Conexion()
            Return donacionArticulo

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Recepción xCanje - Retorna el historial a la grid 2, por Fecha.
    '-----------------------------------------------------
    Public Shared Function cargaHistorialxFechaRecepcionXCanje(ByVal fecha As String) As HistorialCanjesRecepcionXCanje

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim retorno As New HistorialCanjesRecepcionXCanje()

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_BUSCAR_CANJES_PORAÑO_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_Periodo", fecha))

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()
                retorno.AgregarRecords(i, lector("FLD_CMVNUMERO"), lector("FLD_PERCODIGO"), lector("FLD_CANFECHA"), lector("FLD_CANDESCRIPCION"), lector("FLD_MOVPRECIO"))
                i = i + 1
            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Recepción xCanje - Retorna el historial a la grid 2, por Numero.
    '-----------------------------------------------------
    Public Shared Function cargaHistorialxNumeroRecepcionXCanje(ByVal numero As String) As HistorialCanjesDespachoXCanje

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim retorno As New HistorialCanjesDespachoXCanje()

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_CANJE_SELALL_PORNUMERO_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", numero))

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()
                retorno.AgregarRecords(i, lector("FLD_CMVNUMERO"), lector("FLD_PERCODIGO"), lector("FLD_CANFECHA"), lector("FLD_CANDESCRIPCION"), lector("FLD_MOVPRECIO"))
                i = i + 1
            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Recepción xCanje - Retorna la informacion historica asociada al canje efectuado en una fecha determinada.
    '-----------------------------------------------------
    Public Shared Function getInfoHistoricoCanjeRecepcionXCanje(ByVal periodo As String, ByVal numero As String) As ListaHistorialRecepcionxCanje

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim retorno As New ListaHistorialRecepcionxCanje()

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_DETALLE_DESPACHOxCANJE")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", numero))

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                retorno.AgregarRecords(i, Convert.ToString(lector("FLD_MATCODIGO")).Trim, Convert.ToString(lector("FLD_MATNOMBRE")).Trim, Convert.ToString(lector("FLD_ITECODIGO")).Trim,
                                       Convert.ToString(lector("FLD_ITEDENOMINACION")).Trim, Convert.ToString(lector("FLD_BODCODIGO")).Trim, Convert.ToString(lector("FLD_BODNOMBRES")).Trim,
                                       Convert.ToString(lector("FLD_MOVCANTIDAD")).Trim, Convert.ToString(lector("CNT_DEVOLVER")).Trim, Convert.ToString(lector("FLD_PRECIOUNITARIO")).Trim)

            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Recepción xCanje - Obtiene el correlativo para el save.
    '-----------------------------------------------------
    Public Shared Function getCorrelativoRecepcionXCanje(ByVal fecha As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..pro_GeneraCorrelativoRecepcionXCanje")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))

        Dim donacionArticulo As New Dictionary(Of String, String)

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            If (lector.Read()) Then
                donacionArticulo.Add("Correlativo", Convert.ToString(lector("Correlativo")).Trim)
            Else
                donacionArticulo.Add("item", "null")
            End If

            dataBase.cerrar_Conexion()
            Return donacionArticulo

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Recepción xCanje - Graba el movimiento.
    '-----------------------------------------------------
    Public Shared Function saveMovimientoRecepcionXCanje(ByVal codigo As String, ByVal fecha As String, ByVal NRecepcionXCanje As String,
                                                         ByVal fechaCompleta As DateTime, ByVal usuario As String, ByVal descripcion As String, ByVal NDespachoCanje As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DEVOLUCIONESxCANJE_INS_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", codigo))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", NRecepcionXCanje))
        comando.Parameters.Add(New SqlParameter("@FLD_DEVFECHA", fechaCompleta))
        comando.Parameters.Add(New SqlParameter("@FLD_USULOGIN", usuario))
        comando.Parameters.Add(New SqlParameter("@FLD_DEVDESCRIPCION", descripcion))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMEROCANJE", NDespachoCanje))

        Dim lector As SqlDataReader = comando.ExecuteReader()
        dataBase.cerrar_Conexion()

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Recepción xCanje - Graba el Detalle del movimiento (articulos).
    '-----------------------------------------------------
    Public Shared Function saveDetalleMovimientoRecepcionXCanje(ByVal codigo As String, ByVal periodo As String, ByVal numero As Integer,
                                                         ByVal movimiento As Integer, ByVal codBodega As String, ByVal matCodigo As String,
                                                         ByVal item As String, ByVal precio As Single, ByVal loteSerie As String, ByVal fechaVencimiento As DateTime)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DEVOLUCIONESxCANJE_DET_INS_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", codigo))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", numero))
        comando.Parameters.Add(New SqlParameter("@FLD_MOVCANTIDAD", movimiento))
        comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", codBodega))
        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", matCodigo))
        comando.Parameters.Add(New SqlParameter("@FLD_ITECODIGO", item))
        comando.Parameters.Add(New SqlParameter("@FLD_PRECIOUNITARIO", precio))
        comando.Parameters.Add(New SqlParameter("@FLD_SERIELOTE", loteSerie))
        comando.Parameters.Add(New SqlParameter("@FLD_FECHAVENCIMIENTO", fechaVencimiento))

        Dim lector As SqlDataReader = comando.ExecuteReader()
        dataBase.cerrar_Conexion()

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Recepción xCanje - Save General - new OCT 2015
    '-----------------------------------------------------
    Public Shared Function saveGeneralRecepXCanje(ByVal usuario As String, ByVal periodo As String, ByVal tipoMovimiento As String,
                                             ByVal fechaCompleta As DateTime, ByVal descripcion As String, ByVal NDespachoCanje As String,
                                             ByVal PeriodoOrigenCanje As String)

        Dim respuesta As New Dictionary(Of String, String)
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_RECEPCION_CANJE_INS_ALL_new2015")

            comando.Parameters.Add(New SqlParameter("@FLD_USULOGIN", usuario))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", tipoMovimiento))
            comando.Parameters.Add(New SqlParameter("@FLD_DEVDESCRIPCION", descripcion))
            comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMEROCANJE", NDespachoCanje))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO_PRE", PeriodoOrigenCanje))

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                respuesta.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                respuesta.Add("FLD_TMVCODIGO", Convert.ToString(lector("FLD_TMVCODIGO")))
                respuesta.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                respuesta.Add("ERROR", Convert.ToString(lector("ERROR")))

            End While

            dataBase.cerrar_Conexion()

            Return respuesta

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            respuesta.Add("FLD_CMVNUMERO", "0")
            respuesta.Add("FLD_TMVCODIGO", "0")
            respuesta.Add("FLD_PERCODIGO", "0")
            respuesta.Add("ERROR", ex.Message)
            Return respuesta

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Recepción xCanje - Verifica que el canje ya este realizado.
    '-----------------------------------------------------
    Public Shared Function CheckRecepcionxCanje(ByVal codigo As String, ByVal fecha As String, ByVal NDespacho As Integer) As ListaCheckRecepcionxCanje

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_RECEPCIONxCANJE_CHECK_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", codigo))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO_PRE", NDespacho))

        Dim retorno As New ListaCheckRecepcionxCanje()

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                retorno.AgregarRecords(Convert.ToString(lector("Numero")).Trim, Convert.ToString(lector("codigo")).Trim, Convert.ToString(lector("RCanje")).Trim,
                                       Convert.ToString(lector("RDescripcion")).Trim, Convert.ToString(lector("NSerie")).Trim, Convert.ToString(lector("FechaVto")).Trim)

            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho - Por Devolucion De Préstamo - Retorna la lista de articulos historicos buscados para grid principal.
    '-----------------------------------------------------
    Public Shared Function getArticulosGrid2_A_Grid1(ByVal codigo As String, ByVal periodo As String, ByVal numero As String) As ListaDeArticulosHistorial_XDevolucionDePrestamo

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim articulos As New ListaDeArticulosHistorial_XDevolucionDePrestamo

        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DETMOVIMIENTOS_ALL_DESPXDEVOLUCIONDePRESTAMO_NEW2014")

        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", codigo))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", numero))

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim value_code As String = Convert.ToString(lector("bodega")).Trim
                'codigo, divide la cadena.
                Dim cadenas As String()
                cadenas = value_code.Split("-")

                articulos.AgregarRecords(lector("codigo de material"), Convert.ToString(lector("nombre de material")).Trim, lector("cantidad movida"), lector("cantidad Devolver"), lector("unidad de medida"),
                                          lector("neto"), lector("total"), lector("precio unitario"), lector("total donacion"),
                                          lector("codigo de item"), cadenas(0), lector("cantidad existente"), lector("Nserie"), lector("fechaVencimiento"))
            End While

            dataBase.cerrar_Conexion()
            Return articulos

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho - Por Devolucion De Préstamo - Obtiene el correlativo para el save.
    '-----------------------------------------------------
    Public Shared Function buscaCorrelativo_Despacho_PorDevolucionDePrestamo(ByVal fecha As String, ByVal Ncorrelativo As Integer, ByVal CodMaterial As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..pro_Busca_Correlativo_DESPACHO_PorDevolucionDePrestamo_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", Ncorrelativo))
        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", CodMaterial))

        Dim donacionArticulo As New Dictionary(Of String, String)

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            If (lector.Read()) Then
                donacionArticulo.Add("Tabla", Convert.ToString(lector("Tabla")).Trim)
            Else
                donacionArticulo.Add("item", "null")
            End If

            dataBase.cerrar_Conexion()
            Return donacionArticulo

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho - Por Devolucion De Préstamo - Obtiene el correlativo para el save.
    '-----------------------------------------------------
    Public Shared Function getCorrelativo_Desp_PorDevolucionDePrestamo(ByVal fecha As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..pro_GeneraCorrelativo_Despacho_PorDevolucionDePrestamo_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))

        Dim donacionArticulo As New Dictionary(Of String, String)

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            If (lector.Read()) Then
                donacionArticulo.Add("Correlativo", Convert.ToString(lector("Correlativo")).Trim)
                donacionArticulo.Add("Tabla", Convert.ToString(lector("Tabla")).Trim)
            Else
                donacionArticulo.Add("item", "null")
            End If

            dataBase.cerrar_Conexion()
            Return donacionArticulo

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho - Por Devolucion De Préstamo - Graba el detalle del movimiento.
    '-----------------------------------------------------
    Public Shared Function saveDetalleMovimiento_PorDevoluDePrestamo(ByVal fechaNueva As String, ByVal NCorrelativoNuevo As String,
                                                                 ByVal CodigoTrasaccionNuevo As String, ByVal fechaAntiguo As String,
                                                                 ByVal NCorrelativoAntiguo As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_PORDEVOLUCIONESDEPRESTAMO_DET_INS_DETALLES_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO_NUEVO", fechaNueva))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO_NUEVO", NCorrelativoNuevo))
        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO_NUEVO", CodigoTrasaccionNuevo))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO_ANTIGUO", fechaAntiguo))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO_ANTIGUO", NCorrelativoAntiguo))

        Dim lector As SqlDataReader = comando.ExecuteReader()
        dataBase.cerrar_Conexion()

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho - Por Devolucion De Préstamo - Graba el Préstamo.
    '-----------------------------------------------------
    Public Shared Function savePrestamo_PorDevoluDePrestamo(ByVal fechaActual As String, ByVal codigoActual As String, ByVal NCorrelativoNuevo As Integer, ByVal fechaCompleta As DateTime,
                                                    ByVal descripcion As String, ByVal valor As Single, ByVal numeroDoc As Integer, ByVal Institucion As String,
                                                    ByVal codigoAntiguo As String, ByVal fechaAntigua As String, ByVal NCorrelativoAntiguo As String)


        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_PRESTAMOS_INS")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fechaActual))
        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", codigoActual))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", NCorrelativoNuevo))
        comando.Parameters.Add(New SqlParameter("@FLD_PREFECHA", fechaCompleta))
        comando.Parameters.Add(New SqlParameter("@FLD_PREDESCRIP ", descripcion))
        comando.Parameters.Add(New SqlParameter("@FLD_MOVPRECIO", valor))
        comando.Parameters.Add(New SqlParameter("@FLD_NRODOC", numeroDoc))
        comando.Parameters.Add(New SqlParameter("@FLD_CODINSTITUTO", Institucion))
        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO_PRESTAMO", codigoAntiguo))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO_PRESTAMO", fechaAntigua))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO_PRESTAMO", NCorrelativoAntiguo))

        Dim lector As SqlDataReader = comando.ExecuteReader()
        dataBase.cerrar_Conexion()

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho - Por Devolucion De Préstamo - Obtiene El encabezado de los datos guardados de la devolucion efectuada.
    '-----------------------------------------------------
    Public Shared Function getDatos_EncabezadoHistotico_PorDevoDePrestamo(ByVal CodigoTrasaccionNuevo As String, ByVal CodigoTrasaccionAntiguo As String,
                                                                      ByVal fechaPrestamo As String, ByVal NcorrelativoAntiguo_Prestamo As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_PORDEVOLUCIONESDEPRESTAMO_ENCABEZADO_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO_NUEVO", CodigoTrasaccionNuevo))
        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO_ANTIGUO", CodigoTrasaccionAntiguo))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fechaPrestamo))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO_ANTIGUO", NcorrelativoAntiguo_Prestamo))

        Dim EncabezadoDevolucion As New Dictionary(Of String, String)
        Dim anioDonacion As String = ""
        Dim fechaServer As String = ""

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            If (lector.Read()) Then
                EncabezadoDevolucion.Add("NDevolucion", Convert.ToString(lector("NDevolucion")).Trim)
                EncabezadoDevolucion.Add("Descripcion", Convert.ToString(lector("Descripcion")).Trim)
                EncabezadoDevolucion.Add("fechaDevPrestamo", Convert.ToString(lector("fechaDevPrestamo")).Trim)
                fechaServer = Convert.ToString(lector("fechaDevPrestamo")).Trim
                anioDonacion = Mid(fechaServer, 7, 4)
                EncabezadoDevolucion.Add("anioDevPrestamo", anioDonacion)

            Else
                EncabezadoDevolucion.Add("item", "null")
            End If

            dataBase.cerrar_Conexion()
            Return EncabezadoDevolucion

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho - Por Devolucion De Préstamo - Retorna Historico de los detalles de los articulos buscando por codigo, bodega y correlativo.
    '-----------------------------------------------------
    Public Shared Function getHistorial_Detalle_PorDevolucionDePrestamo(ByVal codigo As String, ByVal bodega As String, ByVal correlativo As Integer, ByVal anioPrestamo As String) As ListaDetalleArticulos

        Dim retorno As New ListaDetalleArticulos()

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_BUSCA_DETALLE_MATERIALES_HISTORICO_DevoluDePrestamo_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codigo))
        comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", bodega))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO_PRESTAMO", correlativo))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO_PRESTAMO", anioPrestamo))

        Dim donacionArticulo As New Dictionary(Of String, String)

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                retorno.AgregarRecords(i, Convert.ToString(lector("FLD_MOVNUMEROLINEA")).Trim, Convert.ToString(lector("FLD_TMVCODIGO")).Trim,
                                       lector("FLD_PERCODIGO"), lector("FLD_CMVNUMERO"), Convert.ToString(lector("FLD_MATCODIGO")).Trim, lector("FLD_MOVCANTIDAD"),
                                       Convert.ToString(lector("FLD_NSERIE")).Trim, lector("FLD_FECHAVENCIMIENTO"))
                i = i + 1

            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho - Por Devolucion De Préstamo - Retorna Historico de los detalles de los articulos buscando por codigo, bodega y correlativo. Tabla 2
    '-----------------------------------------------------
    Public Shared Function getHistorial_DetalleTemp_PorDevoDePrestamo(ByVal codigo As String, ByVal bodega As String, ByVal correlativo As Integer) As ListaDetalleArticulos

        Dim retorno As New ListaDetalleArticulos()

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_BUSCATEMP_DETALLE_MATERIALES_HISTORICO_PorDevolDePrestamo_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codigo))
        comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", bodega))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", correlativo))

        Dim donacionArticulo As New Dictionary(Of String, String)

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                retorno.AgregarRecords(i, Convert.ToString(lector("FLD_MOVNUMEROLINEA")).Trim, Convert.ToString(lector("FLD_TMVCODIGO")).Trim,
                                       lector("FLD_PERCODIGO"), lector("FLD_CMVNUMERO"), Convert.ToString(lector("FLD_MATCODIGO")).Trim, lector("FLD_MOVCANTIDAD_DETALLE"),
                                       Convert.ToString(lector("FLD_NSERIE")).Trim, lector("FLD_FECHAVENCIMIENTO"))
                i = i + 1

            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho - Por Devolucion De Préstamo - Graba el detalle del movimiento, para cada articulo en la tabla TEMP.
    '-----------------------------------------------------
    Public Shared Function saveTempRecep_PorDevolucionDePrestamo(ByVal cont As String, ByVal NumeroDonacionArticulo As String, ByVal fecha As String,
                                                                      ByVal NumeroCorrelativo As String, ByVal CantidadMovimientoG As Integer, ByVal CantidadMovimientoD As Integer,
                                                                      ByVal CodigoMaterial As String, ByVal NSerie As String, ByVal FechaVto As DateTime,
                                                                      ByVal CodBodega As String, ByVal ItemArticulo As String, ByVal PrecioUni As Single)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DETMOVIMIENTOS_INS_DETALLE_TEMP_PorDEVOLUDePRESTAMO_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_MOVNUMEROLINEA", cont))
        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", NumeroDonacionArticulo))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", NumeroCorrelativo))
        comando.Parameters.Add(New SqlParameter("@FLD_MOVCANTIDAD_GENERAL", CantidadMovimientoG))
        comando.Parameters.Add(New SqlParameter("@FLD_MOVCANTIDAD_DETALLE", CantidadMovimientoD))
        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", CodigoMaterial))
        comando.Parameters.Add(New SqlParameter("@FLD_NSERIE", NSerie))
        comando.Parameters.Add(New SqlParameter("@FLD_FECHAVENCIMIENTO", FechaVto))
        comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", CodBodega))
        comando.Parameters.Add(New SqlParameter("@FLD_ITECODIGO", ItemArticulo))
        comando.Parameters.Add(New SqlParameter("@FLD_PRECIOUNITARIO", PrecioUni))


        Dim lector As SqlDataReader = comando.ExecuteReader()
        dataBase.cerrar_Conexion()

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho - OtrasInstituciones - Extraer las fechas del form de la DespachoxOtrasInstituciones
    '-----------------------------------------------------
    Public Shared Function getListaFechasServidorDespacho() As ListaDeFechaDespacho

        Dim listafechas As New ListaDeFechaDespacho
        Dim dataBase As BaseDatos = getBaseDatos()

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_GEN_TRAEFECHASERVIDOR")

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()
            Dim fechaServer As String = ""
            Dim anioPrestamo As String = ""

            While lector.Read()
                fechaServer = lector("Fld_FechaActual")
                anioPrestamo = Mid(fechaServer, 7, 4)
            End While

            listafechas.AgregarRecords(fechaServer, anioPrestamo)

            dataBase.cerrar_Conexion()
            Return listafechas

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho - OtrasInstituciones - Obtiene el correlativo para el save.
    '-----------------------------------------------------
    Public Shared Function getCorrelativoDespOtrasInstituciones(ByVal fecha As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..pro_GeneraCorrelativoPrestamo_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))

        Dim donacionArticulo As New Dictionary(Of String, String)

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            If (lector.Read()) Then
                donacionArticulo.Add("Correlativo", Convert.ToString(lector("Correlativo")).Trim)
                donacionArticulo.Add("Tabla", Convert.ToString(lector("Tabla")).Trim)
            Else
                donacionArticulo.Add("item", "null")
            End If

            dataBase.cerrar_Conexion()
            Return donacionArticulo

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho - OtrasInstituciones - Obtiene el correlativo para el save.
    '-----------------------------------------------------
    Public Shared Function BuscaCorrelativoDespOtrasInstituciones(ByVal fecha As String, ByVal Ncorrelativo As Integer, ByVal CodMaterial As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..pro_Busca_CorrelativoPrestamo_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", Ncorrelativo))
        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", CodMaterial))

        Dim donacionArticulo As New Dictionary(Of String, String)

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            If (lector.Read()) Then
                donacionArticulo.Add("Tabla", Convert.ToString(lector("Tabla")).Trim)
            Else
                donacionArticulo.Add("item", "null")
            End If

            dataBase.cerrar_Conexion()
            Return donacionArticulo

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho - OtrasInstituciones - Graba el Préstamo.
    '-----------------------------------------------------
    Public Shared Function savePrestamoDespOtrasInstituciones(ByVal fecha As String, ByVal NumeroDonacionArticulo As String, ByVal Ncorrelativo As Integer, ByVal fechaCompleta As DateTime,
                                                 ByVal descripcion As String, ByVal valor As Single, ByVal numeroDoc As Integer, ByVal codInstitucion As String)


        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_PRESTAMOS_INS")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))
        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", NumeroDonacionArticulo))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", Ncorrelativo))
        comando.Parameters.Add(New SqlParameter("@FLD_PREFECHA", fechaCompleta))
        comando.Parameters.Add(New SqlParameter("@FLD_PREDESCRIP ", descripcion))
        comando.Parameters.Add(New SqlParameter("@FLD_MOVPRECIO", valor))
        comando.Parameters.Add(New SqlParameter("@FLD_NRODOC", numeroDoc))
        comando.Parameters.Add(New SqlParameter("@FLD_CODINSTITUTO", codInstitucion))
        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO_PRESTAMO", NumeroDonacionArticulo))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO_PRESTAMO", fecha))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO_PRESTAMO", Ncorrelativo))

        Dim lector As SqlDataReader = comando.ExecuteReader()
        dataBase.cerrar_Conexion()

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho - OtrasInstituciones - Graba el detalle del movimiento.
    '-----------------------------------------------------
    Public Shared Function saveDetalleMovimientoOtrasInst(ByVal fecha As String, ByVal NumeroCorrelativo As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        'Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DETMOVIMIENTOS_INS_RECEPCION_DONACION_NEW2014")
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DETMOVIMIENTOS_INS_ALL_DETALLES_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO1", fecha))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO1", NumeroCorrelativo))


        Dim lector As SqlDataReader = comando.ExecuteReader()
        dataBase.cerrar_Conexion()

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho - OtrasInstituciones - Graba el detalle del movimiento, para cada articulo en la tabla TEMP.
    '-----------------------------------------------------
    Public Shared Function saveDetalleMovimientoOtrasInst_DetalleTemp(ByVal cont As String, ByVal NumeroDonacionArticulo As String, ByVal fecha As String,
                                                                      ByVal NumeroCorrelativo As String, ByVal CantidadMovimientoG As Integer, ByVal CantidadMovimientoD As Integer,
                                                                      ByVal CodigoMaterial As String, ByVal NSerie As String, ByVal FechaVto As DateTime,
                                                                      ByVal CodBodega As String, ByVal ItemArticulo As String, ByVal PrecioUni As Single)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DETMOVIMIENTOS_INS_DETALLE_TEMP_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_MOVNUMEROLINEA", cont))
        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", NumeroDonacionArticulo))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", NumeroCorrelativo))
        comando.Parameters.Add(New SqlParameter("@FLD_MOVCANTIDAD_GENERAL", CantidadMovimientoG))
        comando.Parameters.Add(New SqlParameter("@FLD_MOVCANTIDAD_DETALLE", CantidadMovimientoD))
        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", CodigoMaterial))
        comando.Parameters.Add(New SqlParameter("@FLD_NSERIE", NSerie))
        comando.Parameters.Add(New SqlParameter("@FLD_FECHAVENCIMIENTO", FechaVto))
        comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", CodBodega))
        comando.Parameters.Add(New SqlParameter("@FLD_ITECODIGO", ItemArticulo))
        comando.Parameters.Add(New SqlParameter("@FLD_PRECIOUNITARIO", PrecioUni))


        Dim lector As SqlDataReader = comando.ExecuteReader()
        dataBase.cerrar_Conexion()

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho - OtrasInstituciones - Elimina el detalle del movimiento, para cada articulo en la tabla TEMP.
    '-----------------------------------------------------
    Public Shared Function delete_DetalleMovimientoOtrasInst_DetalleTemp(ByVal NumeroDonacionArticulo As String, ByVal CodigoMaterial As String, ByVal NumeroActual As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DETMOVIMIENTOS_DEL_DETALLE_TEMP_NET2015")

        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", NumeroDonacionArticulo))
        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", CodigoMaterial))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", NumeroActual))

        Dim lector As SqlDataReader = comando.ExecuteReader()
        dataBase.cerrar_Conexion()

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho - OtrasInstituciones - Retorna el historial a la grid 2 
    '                                       de prestamos,busqueda por Fecha.
    '-----------------------------------------------------
    Public Shared Function cargaHistorialxFecha_DespOtrasInst(ByVal fecha As String) As ListaGrid2HistoricoxDespOtrasInst

        Dim retorno As New ListaGrid2HistoricoxDespOtrasInst()

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_PRESTAMOS_SEL_PORFECHA_NEW2014")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim value_code As String = Convert.ToString(lector("INSTITUTO")).Trim
                'codigo, divide la cadena.
                Dim cadenas As String()
                cadenas = value_code.Split("-")

                retorno.AgregarRecords(i, lector("FLD_PERCODIGO"), lector("FLD_CMVNUMERO"), lector("FLD_PREFECHA"), lector("FLD_NRODOC"), lector("FLD_PREDESCRIPCION"), lector("Fld_MOVPRECIO"), cadenas(0))
                i = i + 1

            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho OtrasInstituciones - Retorna el historial a la grid 2 
    '                                       de prestamos,busqueda por Numero Prestamo.
    '-----------------------------------------------------
    Public Shared Function cargaHistorialxNPrestamo_DespOtrasInst(ByVal NPrestamo As String) As ListaGrid2HistoricoxDespOtrasInst

        Dim retorno As New ListaGrid2HistoricoxDespOtrasInst()

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_PRESTAMOS_SEL_PORNUMERO_NEW2014")

        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", NPrestamo))

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                retorno.AgregarRecords(i, lector("FLD_PERCODIGO"), lector("FLD_CMVNUMERO"), lector("FLD_PREFECHA"), lector("FLD_NRODOC"), lector("FLD_PREDESCRIPCION"), lector("Fld_MOVPRECIO"), lector("INSTITUTO"))
                i = i + 1

            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho - OtrasInstituciones - Retorna el historial de articulos al Grid1.
    '-----------------------------------------------------
    Public Shared Function cargaHistorialAGrid1DespOtrasInst(ByVal codigo As String, ByVal periodo As String, ByVal numero As String) As ListaArticulosGrid1DespOtrasInst

        Dim retorno As New ListaArticulosGrid1DespOtrasInst()

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_PRESTAMOS_VIEW_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", codigo))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", numero))

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim value_code As String = Convert.ToString(lector("BODEGA")).Trim
                'codigo, divide la cadena.
                Dim cadenas As String()
                cadenas = value_code.Split("-")

                retorno.AgregarRecords(i, Convert.ToString(lector("FLD_MATCODIGO")).Trim, Convert.ToString(lector("FLD_MATNOMBRE")).Trim, lector("FLD_ITECODIGO"),
                                           lector("FLD_CANTIDAD"), lector("FLD_PRECIOUNITARIO"), lector("FLD_TOTAL_PRESTAMO"),
                                           lector("FLD_EXICANTIDAD"), cadenas(0), lector("FLD_NSERIE"), lector("FLD_FECHAVENCIMIENTO"))
                i = i + 1

            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho - OtrasInstituciones - Retorna los detalles de los articulos buscando por codigo y bodega.
    '-----------------------------------------------------
    Public Shared Function getDetalleProductosOrderFechaDOInst(ByVal codigo As String, ByVal bodega As String) As ListaDetalleArticulos

        Dim retorno As New ListaDetalleArticulos()

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_BUSCA_DETALLE_MATERIALES_DespOInt_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codigo))
        comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", bodega))

        Dim donacionArticulo As New Dictionary(Of String, String)

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                retorno.AgregarRecords(i, Convert.ToString(lector("FLD_MOVNUMEROLINEA")).Trim, Convert.ToString(lector("FLD_TMVCODIGO")).Trim,
                                       lector("FLD_PERCODIGO"), lector("FLD_CMVNUMERO"), Convert.ToString(lector("FLD_MATCODIGO")).Trim, lector("FLD_MOVCANTIDAD"),
                                       Convert.ToString(lector("FLD_NSERIE")).Trim, lector("FLD_FECHAVENCIMIENTO"))
                i = i + 1

            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho - OtrasInstituciones - Retorna Historico de los detalles de los articulos buscando por codigo, bodega y correlativo.
    '-----------------------------------------------------
    Public Shared Function getHistoricoDetalleProductosOrderFechaDOInst(ByVal codigo As String, ByVal bodega As String, ByVal correlativo As Integer) As ListaDetalleArticulos

        Dim retorno As New ListaDetalleArticulos()

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_BUSCA_DETALLE_MATERIALES_HISTORICO_DespOInt_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codigo))
        comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", bodega))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", correlativo))

        Dim donacionArticulo As New Dictionary(Of String, String)

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                retorno.AgregarRecords(i, Convert.ToString(lector("FLD_MOVNUMEROLINEA")).Trim, Convert.ToString(lector("FLD_TMVCODIGO")).Trim,
                                       lector("FLD_PERCODIGO"), lector("FLD_CMVNUMERO"), Convert.ToString(lector("FLD_MATCODIGO")).Trim, lector("FLD_MOVCANTIDAD"),
                                       Convert.ToString(lector("FLD_NSERIE")).Trim, lector("FLD_FECHAVENCIMIENTO"))
                i = i + 1

            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho - OtrasInstituciones - Retorna Historico de los detalles de los articulos buscando por codigo, bodega y correlativo.
    '-----------------------------------------------------
    Public Shared Function getHistoricoTEMPDetalleProductosOrderFechaDOInst(ByVal codigo As String, ByVal bodega As String, ByVal correlativo As Integer) As ListaDetalleArticulos

        Dim retorno As New ListaDetalleArticulos()

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_BUSCATEMP_DETALLE_MATERIALES_HISTORICO_DespOInt_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codigo))
        comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", bodega))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", correlativo))

        Dim donacionArticulo As New Dictionary(Of String, String)

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                retorno.AgregarRecords(i, Convert.ToString(lector("FLD_MOVNUMEROLINEA")).Trim, Convert.ToString(lector("FLD_TMVCODIGO")).Trim,
                                       lector("FLD_PERCODIGO"), lector("FLD_CMVNUMERO"), Convert.ToString(lector("FLD_MATCODIGO")).Trim, lector("FLD_MOVCANTIDAD_DETALLE"),
                                       Convert.ToString(lector("FLD_NSERIE")).Trim, lector("FLD_FECHAVENCIMIENTO"))
                i = i + 1

            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------------------------------
    '  Nuevo - Despacho xCanje - Extraer lista de Proveedores para Despacho x Caje.
    '-----------------------------------------------------------------------------
    Public Shared Function getListaProveedoresxCanje() As ListaProveedores

        Dim listaProveedores As New ListaProveedores


        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_PROVEEDORES_CARGACOMBO")

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim value_code As String = Convert.ToString(lector("PROVEEDOR")).Trim
                'programa es dividido y se extrae el codigo de programa.
                Dim cadenas As String()
                cadenas = value_code.Split("-")

                Dim str As String = cadenas(1)
                Dim cadenaUltimoDigito As String()
                cadenaUltimoDigito = str.Split(" ")

                Dim ultimoDigito As String = cadenaUltimoDigito(0)

                Dim rutCompleto As String = cadenas(0) & ultimoDigito


                listaProveedores.AgregarRecords(rutCompleto, value_code)

            End While

            dataBase.cerrar_Conexion()
            Return listaProveedores

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho xCanje - Retorna el historial a la grid 2, por Fecha.
    '-----------------------------------------------------
    Public Shared Function cargaHistorialxFechaDespachoXCanje(ByVal fecha As String) As HistorialCanjesDespachoXCanje

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim retorno As New HistorialCanjesDespachoXCanje()

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_CANJE_SELALL_PORFECHA_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()
                retorno.AgregarRecords(i, lector("FLD_CMVNUMERO"), lector("FLD_PERCODIGO"), lector("FLD_CANFECHA"), lector("FLD_CANDESCRIPCION"), lector("FLD_MOVPRECIO"))
                i = i + 1
            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho xCanje - Retorna el historial a la grid 2, por Numero.
    '-----------------------------------------------------
    Public Shared Function cargaHistorialxNumeroDespachoXCanje(ByVal numero As String) As HistorialCanjesDespachoXCanje

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim retorno As New HistorialCanjesDespachoXCanje()

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_CANJE_SELALL_PORNUMERO_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", numero))

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()
                retorno.AgregarRecords(i, lector("FLD_CMVNUMERO"), lector("FLD_PERCODIGO"), lector("FLD_CANFECHA"), lector("FLD_CANDESCRIPCION"), lector("FLD_MOVPRECIO"))
                i = i + 1
            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho xCanje - Retorna la infromacion asociada al canje efectuado en una fecha determinada.
    '-----------------------------------------------------
    Public Shared Function getInfoCanjeDespachoXCanje(ByVal periodo As String, ByVal numero As String)

        Dim dataBase As BaseDatos = getBaseDatos()

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_CANJE_SEL_NET2015")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", numero))

        Dim infoCanje As New Dictionary(Of String, String)

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            If (lector.Read()) Then

                infoCanje.Add("anioCanje", Convert.ToString(lector("Fld_PerCodigo")).Trim)
                infoCanje.Add("NCanje", Convert.ToString(lector("Fld_CmvNumero")).Trim)
                infoCanje.Add("fechaCanje", Convert.ToString(lector("Fld_Canfecha")).Trim)
                infoCanje.Add("descripcion", Convert.ToString(lector("Fld_CanDescripcion")).Trim)
                infoCanje.Add("totalCanje", Convert.ToString(lector("Fld_MovPrecio")).Trim)

                Dim value_code As String = Convert.ToString(lector("PROVEEDOR")).Trim
                'proveedor es dividido y se extrae el codigo de proveedor.
                Dim cadenas As String()
                cadenas = value_code.Split("-")

                Dim str As String = cadenas(1)
                Dim cadenaUltimoDigito As String()
                cadenaUltimoDigito = str.Split(" ")
                ' Une el Rut Completo
                Dim ultimoDigito As String = cadenaUltimoDigito(0)
                Dim rutCompleto As String = cadenas(0) & ultimoDigito

                infoCanje.Add("proveedor", rutCompleto)

            Else
                infoCanje.Add("item", "null")
            End If

            dataBase.cerrar_Conexion()
            Return infoCanje

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho xCanje - Obtiene el correlativo para el save.
    '-----------------------------------------------------
    Public Shared Function getCorrelativoDespachoXCanje(ByVal fecha As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..pro_GeneraCorrelativoCanje")

        comando.Parameters.Add(New SqlParameter("@Fld_PerCodigo", fecha))

        Dim donacionArticulo As New Dictionary(Of String, String)

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            If (lector.Read()) Then
                donacionArticulo.Add("Correlativo", Convert.ToString(lector("Correlativo")).Trim)
            Else
                donacionArticulo.Add("item", "null")
            End If

            dataBase.cerrar_Conexion()
            Return donacionArticulo

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho xCanje - Graba el detalle del movimiento.
    '-----------------------------------------------------
    Public Shared Function saveDetalleMov_DespxCanje(ByVal cont As String, ByVal NumeroDonacionArticulo As String, ByVal fecha As String, ByVal NumeroCorrelativo As String,
                                                 ByVal CantidadMovimiento As Single, ByVal dbodega As String, ByVal CodigoMaterial As String, ByVal ItemMaterial As String,
                                                 ByVal null As Single, ByVal null2 As Single, ByVal null3 As Single, ByVal PrecioUnitario As Single,
                                                 ByVal loteSerie As String, ByVal fechaVencimiento As DateTime)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DETMOVIMIENTOS_INS_DESP_CANJE_NEW2015")

        comando.Parameters.Add(New SqlParameter("@FLD_MOVNUMEROLINEA", cont))
        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", NumeroDonacionArticulo))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", NumeroCorrelativo))
        comando.Parameters.Add(New SqlParameter("@FLD_MOVCANTIDAD", CantidadMovimiento))
        comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", dbodega))
        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", CodigoMaterial))
        comando.Parameters.Add(New SqlParameter("@FLD_ITECODIGO", ItemMaterial))
        comando.Parameters.Add(New SqlParameter("@FLD_CANTPEDIDA", null))
        comando.Parameters.Add(New SqlParameter("@FLD_CANTADEVOLVER", null2))
        comando.Parameters.Add(New SqlParameter("@FLD_CANTPENDIENTE", null3))
        comando.Parameters.Add(New SqlParameter("@FLD_PRECIOUNITARIO", PrecioUnitario))
        comando.Parameters.Add(New SqlParameter("@FLD_SERIELOTE", loteSerie))
        comando.Parameters.Add(New SqlParameter("@FLD_FECHAVENCIMIENTO", fechaVencimiento))


        Dim lector As SqlDataReader = comando.ExecuteReader()
        dataBase.cerrar_Conexion()

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho xCanje - Graba el Canje.
    '-----------------------------------------------------
    Public Shared Function saveCanjeDespachoXCanje(ByVal fecha As String, ByVal NumeroDonacionArticulo As String, ByVal Ncorrelativo As Integer, ByVal fechaCompleta As DateTime,
                                                 ByVal descripcion As String, ByVal valor As Single, ByVal rut As Integer, ByVal digitoRut As String)


        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_CANJE_INS")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))
        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", NumeroDonacionArticulo))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", Ncorrelativo))
        comando.Parameters.Add(New SqlParameter("@FLD_PREFECHA", fechaCompleta))
        comando.Parameters.Add(New SqlParameter("@FLD_PREDESCRIP ", descripcion))
        comando.Parameters.Add(New SqlParameter("@FLD_MOVPRECIO", valor))
        comando.Parameters.Add(New SqlParameter("@FLD_PRORUT", rut))
        comando.Parameters.Add(New SqlParameter("@FLD_PRODIGITO", digitoRut))

        Dim lector As SqlDataReader = comando.ExecuteReader()
        dataBase.cerrar_Conexion()

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Stock de Emergencia - Extrae lista de Establecimientos.
    '-----------------------------------------------------
    Public Shared Function getListaEstablecimientos_StockEmergencia() As ListaEstablecimientos

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim listaEstablecimientos As New ListaEstablecimientos

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_ESTABLECIMIENTOS_CARGACOMBO")

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim value_code As String = Convert.ToString(lector("Establecimientos")).Trim
                'codigo, divide la cadena.
                Dim cadenas As String()
                cadenas = value_code.Split("-")
                listaEstablecimientos.AgregarRecords(Convert.ToString(cadenas(0)).Trim, value_code)

            End While

            dataBase.cerrar_Conexion()
            Return listaEstablecimientos

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '----------------------------------------------------- 
    '-----------------------------------------------------
    '  Nuevo - Stock de Emergencia - Extrae lista de Familia de Productos.
    '-----------------------------------------------------
    Public Shared Function getListaFamiliaProductos_StockEmergencia() As ListaFamiliaProductos

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim listaFamiliaProductos As New ListaFamiliaProductos
        Dim TestPos As Integer

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_Busca_CODMaterial_StockEmergencia_NET2014")

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            listaFamiliaProductos.AgregarRecords("todas", "Todas")

            While lector.Read()

                Dim value_code As String = Convert.ToString(lector("MATCODIGO")).Trim

                TestPos = InStr(1, value_code, "-")

                If (TestPos = 0) Then
                    listaFamiliaProductos.AgregarRecords(value_code, value_code)
                Else
                    'codigo, divide la cadena.
                    Dim cadenas As String()
                    cadenas = value_code.Split("-")
                    listaFamiliaProductos.AgregarRecords(Convert.ToString(cadenas(0)).Trim, cadenas(0))

                End If

            End While

            dataBase.cerrar_Conexion()
            Return listaFamiliaProductos

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '----------------------------------------------------- 
    '-----------------------------------------------------
    '  Nuevo - REPORTE - AJUSTE MATERIALES / obtiene el detalle de los materiales para el ajuste
    '-----------------------------------------------------
    Public Shared Function getInfoDetalleMaterialesAjuste(ByVal bodega As String, ByVal codMaterial As String) As ListaMaterialesAjuste

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim retorno As New ListaMaterialesAjuste()

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_DETALLE_AJUSTEMATERIAL")

        comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", bodega))
        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codMaterial))

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                retorno.AgregarRecords(i, Convert.ToString(lector("FLD_TMVDESCRIPCION")).Trim, Convert.ToString(lector("FLD_PERCODIGO")).Trim, Convert.ToString(lector("FLD_CMVNUMERO")).Trim,
                                        Convert.ToString(lector("FLD_MATCODIGO")).Trim, Convert.ToString(lector("FLD_MOVCANTIDAD")).Trim, Convert.ToString(lector("FLD_EXICANTIDAD")).Trim, Convert.ToString(lector("FLD_NSERIE")).Trim,
                                       Convert.ToString(lector("FLD_FECHAVENCIMIENTO")).Trim)
                i = i + 1
            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - REPORTE - AJUSTE MATERIALES / obtiene el detalle de los materiales para el ajuste
    '-----------------------------------------------------
    Public Shared Function getInfoDataAjusteExistencia(ByVal NroAjuste As Integer, ByVal Periodo As String) As ListaMovAjustes

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim retorno As New ListaMovAjustes()

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_SEL_AJUSTE_MATERIAL_new2015")

        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", NroAjuste))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", Periodo))

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                retorno.AgregarRecords(i, Convert.ToString(lector("FLD_CMVNUMERO")).Trim, Convert.ToString(lector("FLD_PERCODIGO")).Trim, Convert.ToString(lector("FLD_AJUFECHA")).Trim,
                                        Convert.ToString(lector("FLD_AJUDESCRIPCION")).Trim, Convert.ToString(lector("FLD_BODEGA")).Trim)
                i = i + 1
            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - REPORTE - AJUSTE MATERIALES / obtiene los tipos de ajuste permitidos
    '-----------------------------------------------------
    Public Shared Function getMotivoAjuste() As ListaMotivoAjuste

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim retorno As New ListaMotivoAjuste()
        'Dim items As New Dictionary(Of String, String)

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_BuscarTipoAjuste")

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                'items.Add("id", Convert.ToString(lector("FLD_CODAJUSTE")).Trim)
                'items.Add("text", Convert.ToString(lector("FLD_CODAJUSTE")).Trim)
                'tipoAjuste.Add("motivoAjuste", Convert.ToString(lector("motivo")).Trim)
                retorno.AgregarRecords(Convert.ToString(lector("FLD_CODAJUSTE")).Trim, Convert.ToString(lector("FLD_DESCAJUSTE")).Trim)

            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - AJUSTE - Save General - new NOVIEMBRE 2015
    '-----------------------------------------------------
    Public Shared Function saveMovimientoAjuste(ByVal usuario As String, ByVal periodo As String, ByVal Bodega As String,
                                             ByVal descripcion As String)

        Dim respuesta As New Dictionary(Of String, String)
        Dim dataBase As BaseDatos = getBaseDatos()

        Dim value_code As String = Bodega
        'codigo, divide la cadena.
        Dim cadenas As String()
        cadenas = value_code.Split("-")

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_AJUSTEMOV_INS_ALL_new2015")

            comando.Parameters.Add(New SqlParameter("@FLD_USULOGIN", usuario))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", cadenas(0)))
            comando.Parameters.Add(New SqlParameter("@FLD_AJUDESCRIPCION", descripcion))


            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                respuesta.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                respuesta.Add("FLD_TMVCODIGO", Convert.ToString(lector("FLD_TMVCODIGO")))
                respuesta.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                respuesta.Add("ERROR", Convert.ToString(lector("ERROR")))

            End While

            dataBase.cerrar_Conexion()

            Return respuesta

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            respuesta.Add("FLD_CMVNUMERO", "0")
            respuesta.Add("FLD_TMVCODIGO", "0")
            respuesta.Add("FLD_PERCODIGO", "0")
            respuesta.Add("ERROR", ex.Message)
            Return respuesta

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - AJUSTE - Save DETALLE General - new NOVIEMBRE 2015
    '-----------------------------------------------------
    Public Shared Function saveDetalleMovimientoAjuste(ByVal tipoMov As Integer, ByVal NumAjuste As Integer, ByVal Periodo As String,
                                             ByVal Bodega As String, ByVal codMaterial As String, ByVal cantEntrada As Integer, ByVal loteReal As String,
                                             ByVal detalle As String, ByVal existChange As Integer, ByVal loteChange As String, ByVal FechaVtoChange As DateTime)

        Dim respuesta As New Dictionary(Of String, String)
        Dim dataBase As BaseDatos = getBaseDatos()

        Dim value_code As String = Bodega
        'codigo, divide la cadena.
        Dim cadenas As String()
        cadenas = value_code.Split("-")

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_AJUSTEMOV_DETALLE_INS_new2015")

            comando.Parameters.Add(New SqlParameter("@TipoAjuste", tipoMov))
            comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", NumAjuste))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", Periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", cadenas(0)))
            comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codMaterial))
            comando.Parameters.Add(New SqlParameter("@FLD_CANTPEDIDA", cantEntrada))
            comando.Parameters.Add(New SqlParameter("@FLD_NSERIE", loteReal))
            comando.Parameters.Add(New SqlParameter("@FLD_OBSERVACION", detalle))
            comando.Parameters.Add(New SqlParameter("@FLD_MOVCANTIDAD", existChange))
            comando.Parameters.Add(New SqlParameter("@FLD_NSERIE_NEW", loteChange))
            comando.Parameters.Add(New SqlParameter("@FLD_FECHAVENCIMIENTO", FechaVtoChange))


            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                respuesta.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                respuesta.Add("FLD_TMVCODIGO", Convert.ToString(lector("FLD_TMVCODIGO")))
                respuesta.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                respuesta.Add("ERROR", Convert.ToString(lector("ERROR")))

            End While

            dataBase.cerrar_Conexion()

            Return respuesta

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            respuesta.Add("FLD_CMVNUMERO", "0")
            respuesta.Add("FLD_TMVCODIGO", "0")
            respuesta.Add("FLD_PERCODIGO", "0")
            respuesta.Add("ERROR", ex.Message)
            Return respuesta

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - AJUSTE - Existencia real Material - new NOVIEMBRE 2015
    '-----------------------------------------------------
    Public Shared Function getValorExistenciaReal(ByVal bodega As String, ByVal codMaterial As String)


        Dim value_code As String = bodega
        'codigo, divide la cadena.
        Dim cadenas As String()
        cadenas = value_code.Split("-")

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_AJUSTE_SEL_CANTEXISTENCIA_new2015")

        comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", cadenas(0)))
        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codMaterial))

        Dim retorno As New Dictionary(Of String, String)

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            If (lector.Read()) Then
                retorno.Add("TotalRealExistencia", Convert.ToString(lector("FLD_EXICANTIDAD")).Trim)
            Else
                retorno.Add("item", "null")
            End If

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    ' Nuevo - AJUSTE - Save para generar reporte - new NOVIEMBRE 2015
    '-----------------------------------------------------
    Public Shared Function CloneInforme_Ajuste(ByVal NTransaccion As Integer, ByVal Periodo As String, ByVal codTransaccion As String, ByVal Linea As Integer, ByVal codMaterial As String,
                ByVal NSerie As String, ByVal CodItem As String, ByVal cantMaterial As Integer, ByVal Bodega As String,
                ByVal descripcion As String, ByVal fechaMovimieno As DateTime, ByVal proveedor As String, ByVal OrdenCompra As Integer, ByVal ordenCompraEstado As String,
                ByVal numeroDocumento As Integer, ByVal Institucion As String, ByVal centroCosto As String, ByVal tipoDocumento As String, ByVal tituloMenu As String,
                ByVal descuento As Single, ByVal impuesto As Single, ByVal diferenciaPeso As Single, ByVal usuario As String)

        Dim respuesta As New Dictionary(Of String, String)
        'Dim respuesta As Integer = 0
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            'Dim linea As Integer = Integer.Parse(detalleMat("linea"))
            'Dim cantidad As Integer = Integer.Parse(detalleMat("cantidad"))
            'Dim fechaMaterial As DateTime = DateTime.Parse(detalleMat("fechaVencimiento"))

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_INFORME_REPORTE_AJUSTE_INS_net")

            comando.Parameters.Add(New SqlParameter("@FLD_NROTRANSACCION", NTransaccion))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", Periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", codTransaccion))
            comando.Parameters.Add(New SqlParameter("@FLD_LINEA", Linea))
            comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codMaterial))
            comando.Parameters.Add(New SqlParameter("@FLD_ITECODIGO", CodItem))             'text 12    | N serie
            comando.Parameters.Add(New SqlParameter("@FLD_CANTIDAD", cantMaterial))
            comando.Parameters.Add(New SqlParameter("@FLD_BODEGA", Bodega))
            comando.Parameters.Add(New SqlParameter("@FLD_OBSERVACION", descripcion))
            comando.Parameters.Add(New SqlParameter("@FLD_FECHA", fechaMovimieno))
            comando.Parameters.Add(New SqlParameter("@FLD_PROVEEDOR", proveedor))           'text 70    | descripcion global
            comando.Parameters.Add(New SqlParameter("@FLD_ORDENCOMPRA", OrdenCompra))       ' num       
            comando.Parameters.Add(New SqlParameter("@FLD_OCOESTADO", ordenCompraEstado))   ' text 60
            comando.Parameters.Add(New SqlParameter("@FLD_NRODOCUMENTO", numeroDocumento))  'int
            comando.Parameters.Add(New SqlParameter("@FLD_INSTITUCION", Institucion))       'text 30    | 
            comando.Parameters.Add(New SqlParameter("@FLD_CENTRO_COSTO", NSerie))           'text 30    | 
            comando.Parameters.Add(New SqlParameter("@FLD_TIPODOCUMENTO", tipoDocumento))   'text 10    | fecha, salida si esta bn
            comando.Parameters.Add(New SqlParameter("@FLD_TITULO", tituloMenu))
            comando.Parameters.Add(New SqlParameter("@FLD_DESCUENTO", 0))
            comando.Parameters.Add(New SqlParameter("@FLD_IMPUESTO", 0))
            comando.Parameters.Add(New SqlParameter("@FLD_DIFPESO", 0))
            comando.Parameters.Add(New SqlParameter("@FLD_USUARIO", usuario))

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                respuesta.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                respuesta.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                respuesta.Add("FLD_TMVCODIGO", Convert.ToString(lector("FLD_TMVCODIGO")))
                respuesta.Add("FLD_USUARIO", Convert.ToString(lector("FLD_USUARIO")))
                respuesta.Add("ERROR", Convert.ToString(lector("ERROR")))

            End While

            dataBase.cerrar_Conexion()

            Return 0

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            respuesta.Add("FLD_CMVNUMERO", "0")
            respuesta.Add("ERROR", ex.Message)
            Return 1
        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Reporte - BinCard - Extrae lista de Materiales.
    '-----------------------------------------------------
    Public Shared Function getListaMateriales_BinCard(ByVal codBodega As String) As ListaMateriales_BinCard

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim listaMateriales As New ListaMateriales_BinCard

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_OBTIENE_MATERIALB")
        'Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_MATERIALES_BINCARD_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", codBodega))

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                'Dim CodMaterial As String = Convert.ToString(lector("COD_MATERIAL")).Trim
                'Dim NombreMaterial As String = Convert.ToString(lector("NOMBRE_MATERIAL")).Trim
                'Dim CodYNombre As String = CodMaterial + " - " + NombreMaterial
                Dim CodMaterial As String = Convert.ToString(lector("FLD_MATCODIGO")).Trim
                Dim NombreMaterial As String = Convert.ToString(lector("FLD_MATNOMBRE")).Trim
                Dim CodYNombre As String = CodMaterial + " - " + NombreMaterial

                listaMateriales.AgregarRecords(CodMaterial, CodYNombre)

            End While

            dataBase.cerrar_Conexion()
            Return listaMateriales

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '----------------------------------------------------- 
    '-----------------------------------------------------
    '  Nuevo - Reporte - BinCard - Extrae lista de Periodos disponibles.
    '-----------------------------------------------------
    Public Shared Function getListaPeriodos_BinCard() As ListaPeriodo

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim listaPeriodo As New ListaPeriodo

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_PERIODO_VIEW")

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim Periodo As String = Convert.ToString(lector("FLD_PERCODIGO")).Trim

                listaPeriodo.AgregarRecords(Periodo, Periodo)

            End While

            dataBase.cerrar_Conexion()
            Return listaPeriodo

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '----------------------------------------------------- 
    '-----------------------------------------------------
    '  Nuevo - Reporte - BinCard - Retorna el historial de transacciones del articulo solicitado.
    '-----------------------------------------------------
    Public Shared Function getListaArticulos_Bincard(ByVal codBodega As String, ByVal codMaterial As String, ByVal anio As String) As ListaArticulos_BinCard

        Dim retorno As New ListaArticulos_BinCard()

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..Pro_CreaBincard_X_Productos_Bdg_NET2015")

        comando.Parameters.Add(New SqlParameter("@Fld_BodCodigo", codBodega))
        comando.Parameters.Add(New SqlParameter("@Fld_MatCodigo", codMaterial))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", anio))

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                'Dim dateBD As String = Convert.ToString(lector("Fld_CmvFecha")).Trim

                Dim time As DateTime = DateTime.Parse(lector("Fld_CmvFecha"))
                Dim dateOnly As Date = time.Date

                retorno.AgregarRecords(i, dateOnly.ToString("d"), lector("Fld_BinDocumento"), lector("Fld_CmvNumero"),
                                       lector("Fld_BinPrecioUnitario"), lector("Fld_BinEntrada"), lector("Fld_BinSalida"),
                                       lector("Fld_BinSaldo"), lector("Fld_BinEntradaV"), lector("Fld_BinSalidaV"),
                                       lector("Fld_BinSaldoV"), lector("Fld_BinPrecioPPM"), Convert.ToString(lector("Fld_BinObservacion")).Trim,
                                       lector("Fld_IteCodigo"), Convert.ToString(lector("Fld_IteDenominacion")).Trim)
                i = i + 1

            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Reporte - BinCard - Obtiene el correlativo para el save.
    '-----------------------------------------------------
    Public Shared Function getCorrelativo_Bincard()

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..pro_GeneraCorrelativo_BinCard_NET2014")

        Dim correlativo As New Dictionary(Of String, String)

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            If (lector.Read()) Then
                correlativo.Add("Correlativo", Convert.ToString(lector("Correlativo")).Trim)
            Else
                correlativo.Add("item", "null")
            End If

            dataBase.cerrar_Conexion()
            Return correlativo

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Reporte - BinCard - Graba cada articulo en la tabla TEMP.
    '-----------------------------------------------------
    Public Shared Function SaveTemp_BinCard(ByVal id_Temp As Integer, ByVal fecha As String, ByVal TipoMov As String, ByVal NDoc As Integer,
                                                ByVal PrecioNeto As Single, ByVal FisicoEntrada As Single, ByVal Salida As Single,
                                                ByVal Saldo As Single, ByVal ValEntrada As Single, ByVal SalidaV As Single, ByVal SaldoV As Single,
                                                ByVal PrecioPonderado As Single, ByVal Obsevacion As String, ByVal CodItem As String, ByVal Descripcion As String,
                                                ByVal Usuario As String, ByVal Bodega As String, ByVal CodMaterial As String, ByVal AnioBincard As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_INS_TEMP_BINCARD_NET2014")

        comando.Parameters.Add(New SqlParameter("@id_Temp", id_Temp))
        comando.Parameters.Add(New SqlParameter("@fecha", fecha))
        comando.Parameters.Add(New SqlParameter("@TipoMov", TipoMov))
        comando.Parameters.Add(New SqlParameter("@NDoc", NDoc))
        comando.Parameters.Add(New SqlParameter("@PrecioNeto", PrecioNeto))
        comando.Parameters.Add(New SqlParameter("@FisicoEntrada", FisicoEntrada))
        comando.Parameters.Add(New SqlParameter("@Salida", Salida))
        comando.Parameters.Add(New SqlParameter("@Saldo", Saldo))
        comando.Parameters.Add(New SqlParameter("@ValEntrada", ValEntrada))
        comando.Parameters.Add(New SqlParameter("@SalidaV", SalidaV))
        comando.Parameters.Add(New SqlParameter("@SaldoV", SaldoV))
        comando.Parameters.Add(New SqlParameter("@PrecioPonderado", PrecioPonderado))
        comando.Parameters.Add(New SqlParameter("@Obsevacion", Obsevacion))
        comando.Parameters.Add(New SqlParameter("@CodItem", CodItem))
        comando.Parameters.Add(New SqlParameter("@Descripcion", Descripcion))
        comando.Parameters.Add(New SqlParameter("@Usuario", Usuario))
        comando.Parameters.Add(New SqlParameter("@Bodega", Bodega))
        comando.Parameters.Add(New SqlParameter("@CodMaterial", CodMaterial))
        comando.Parameters.Add(New SqlParameter("@AnioBincard", AnioBincard))

        Dim lector As SqlDataReader = comando.ExecuteReader()
        dataBase.cerrar_Conexion()

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Reporte - BinCard - Extraer lista de bodegas para Bincard General.
    '-----------------------------------------------------
    Public Shared Function getListaBodega_Bincard(ByVal CentroCosto As String, ByVal establecimiento As String) As ListaBodega

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim listaBodegas As New ListaBodega

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_BODEGAS_CARGACOMBOxCCOSTO")

        comando.Parameters.Add(New SqlParameter("@FLD_ESTCODIGO", establecimiento))
        comando.Parameters.Add(New SqlParameter("@FLD_CCOCODIGO", CentroCosto))

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim value_code As String = Convert.ToString(lector("BODEGAS")).Trim
                listaBodegas.AgregarRecords(value_code, value_code)
            End While

            dataBase.cerrar_Conexion()
            Return listaBodegas

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '----------------------------------------------------- 
    '---------------------------------------------------------------
    '  Nuevo - Reporte - BinCard - Verifica si existe el material en la bodega indicada.
    '-----------------------------------------------------
    Public Shared Function busca_Bodega_Material_Bincard(ByVal Bodega As String, ByVal Material As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_BUSCA_BODEGA_MATERIAL_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_BODEGA", Bodega))
        comando.Parameters.Add(New SqlParameter("@FLD_MATERIAL", Material))

        Dim existe As New Dictionary(Of String, String)

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            If (lector.Read()) Then
                existe.Add("existe", Convert.ToString(lector("existe")).Trim)
            Else
                existe.Add("item", "null")
            End If

            dataBase.cerrar_Conexion()
            Return existe

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '---------------------------------------------------------------
    '  Nuevo - Reporte - BinCard - Borra la Busqueda previa de la tabla temporal.
    '-----------------------------------------------------
    Public Shared Function Delete_TEMP_Bincard(ByVal ID_TEMP As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_DEL_TEMP_BINCARD_NET2014")

        comando.Parameters.Add(New SqlParameter("@ID_TEMP", ID_TEMP))

        comando.ExecuteReader()

        dataBase.cerrar_Conexion()

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Reporte - Estados Ordenes Compras - Retorna la lista de Estados disponibles para las ordenes de Compra.
    '-----------------------------------------------------
    Public Shared Function getListaEstados_EstadosOC() As ListaEstados_EstadosOC

        Dim retorno As New ListaEstados_EstadosOC()

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_ESTADOS_OCO_VIEW")


        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                retorno.AgregarRecords(Convert.ToString(lector("FLD_OCOESTADO")).Trim, Convert.ToString(lector("FLD_OCOESTADO")).Trim + " - " + Convert.ToString(lector("FLD_DESCRIPCION")).Trim)

            End While

            retorno.AgregarRecords("TODOS", "TODOS")

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Reporte - Estados Ordenes Compras - Retorna segun rut proveedores para grid 2.
    '-----------------------------------------------------
    Public Shared Function getProveedores_EstadosOC(ByVal dato As String, ByVal tipo As String) As ListaProeedores_EstadosOC

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim retorno As New ListaProeedores_EstadosOC()

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_BUSCAR_PROVEEDORES_ESTADOSOC_NET2014")

        comando.Parameters.Add(New SqlParameter("@FLD_DATO", dato))
        comando.Parameters.Add(New SqlParameter("@TipoBusqueda", tipo))

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()
                retorno.AgregarRecords(i, lector("FULL_RUT"), lector("FLD_PRORAZONSOC"), lector("FLD_PRODIRECCION"), lector("FLD_PROFONO"), lector("FLD_PROCIUDAD"), lector("FLD_PROCONTACTO"), lector("FLD_PRORUT"))
                i = i + 1
            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Reporte - Estados Ordenes Compras - Extraer lista de bodegas para Estados Ordenes de Compra.
    '-----------------------------------------------------
    Public Shared Function getListaBodegas_EstadosOC(ByVal CentroCosto As String, ByVal establecimiento As String) As ListaBodega

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim listaBodegas As New ListaBodega

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_BODEGAS_CARGACOMBOxCCOSTO")

        comando.Parameters.Add(New SqlParameter("@FLD_ESTCODIGO", establecimiento))
        comando.Parameters.Add(New SqlParameter("@FLD_CCOCODIGO", CentroCosto))

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim value_code As String = Convert.ToString(lector("BODEGAS")).Trim
                'codigo, divide la cadena.
                Dim cadenas As String()
                cadenas = value_code.Split("-")
                listaBodegas.AgregarRecords(cadenas(0), value_code)
                'listaBodegas.AgregarRecords(i, lector("BODEGAS"))
            End While

            listaBodegas.AgregarRecords("TODAS", "TODAS")

            dataBase.cerrar_Conexion()
            Return listaBodegas

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '----------------------------------------------------- 
    '-----------------------------------------------------
    '  Nuevo - Reporte - Stock Critico Minimo Maximo - Obtiene el correlativo para el save.
    '-----------------------------------------------------
    Public Shared Function getCorrelativo_Stock_CriMinMax()

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..pro_GeneraCorrelativo_Stock_CriMinMax_NET2014")

        Dim correlativo As New Dictionary(Of String, String)

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            If (lector.Read()) Then
                correlativo.Add("Correlativo", Convert.ToString(lector("Correlativo")).Trim)
            Else
                correlativo.Add("item", "null")
            End If

            dataBase.cerrar_Conexion()
            Return correlativo

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '---------------------------------------------------------------
    '  Nuevo - Reporte -  Stock Critico Minimo Maximo - Borra la Busqueda previa de la tabla temporal.
    '-----------------------------------------------------
    Public Shared Function Delete_TEMP_Stock_CriMinMax(ByVal ID_TEMP As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_DEL_TEMP_STOCK_CRIMINMAX_NET2014")

        comando.Parameters.Add(New SqlParameter("@ID_TEMP", ID_TEMP))

        comando.ExecuteReader()

        dataBase.cerrar_Conexion()

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Reporte - Fecha Vencimiento Periodo Material - Extrae lista de Materiales.
    '-----------------------------------------------------
    Public Shared Function getListaMateriales_FVto_PeriMate(ByVal codBodega As String) As ListaMateriales_BinCard

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim listaMateriales As New ListaMateriales_BinCard

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_OBTIENE_MATERIALB")

        comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", codBodega))

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            listaMateriales.AgregarRecords("%", " % - TODOS LOS MATERIALES ")

            While lector.Read()

                'Dim CodMaterial As String = Convert.ToString(lector("COD_MATERIAL")).Trim
                'Dim NombreMaterial As String = Convert.ToString(lector("NOMBRE_MATERIAL")).Trim
                'Dim CodYNombre As String = CodMaterial + " - " + NombreMaterial
                Dim CodMaterial As String = Convert.ToString(lector("FLD_MATCODIGO")).Trim
                Dim NombreMaterial As String = Convert.ToString(lector("FLD_MATNOMBRE")).Trim
                Dim CodYNombre As String = CodMaterial + " - " + NombreMaterial

                listaMateriales.AgregarRecords(CodMaterial, CodYNombre)

            End While

            dataBase.cerrar_Conexion()
            Return listaMateriales

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '----------------------------------------------------- 
    '-----------------------------------------------------
    '  Nuevo - Reporte - Material/Farmaco Sin Movimiento - Retorna el historial de Movimientos de un Material.
    '-----------------------------------------------------
    Public Shared Function getListaArticulos_MatFar_SinMov(ByVal fechaIni As String, ByVal fechaTermi As String, ByVal bodega As String, ByVal stock As String) As ListaArticulos_MatFar_SinMov

        Dim retorno As New ListaArticulos_MatFar_SinMov()

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_RptMatSinMov")

        comando.Parameters.Add(New SqlParameter("@F_INI", fechaIni))
        comando.Parameters.Add(New SqlParameter("@F_FIN", fechaTermi))
        comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", bodega))
        comando.Parameters.Add(New SqlParameter("@Stock", stock))

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()
            comando.CommandTimeout = 0

            While lector.Read()

                Dim time As DateTime = DateTime.Parse(lector("FECHA"))
                Dim dateOnly As Date = time.Date

                retorno.AgregarRecords(i, lector("FLD_MATCODIGO"), lector("FLD_MATNOMBRE"), lector("FLD_EXICANTIDAD"),
                                       dateOnly.ToString("d"), lector("CMVNUMERO"), lector("TIPOMOV"), lector("Stock_str"))
                i = i + 1

            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Reporte - Inventario / InventarioXItems  - Extrae lista de Items.
    '-----------------------------------------------------
    Public Shared Function getListaItems_InvenXItem() As ListaItems_InveXItem

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim listaItems As New ListaItems_InveXItem

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_ITEMSPRESUPUESTARIOS_CARGACOMBO")

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim ItemCod As String = Convert.ToString(lector("FLD_ITECODIGO")).Trim
                Dim ItemNom As String = Convert.ToString(lector("FLD_ITEDENOMINACION")).Trim
                Dim ItemDeno As String = Convert.ToString(lector("FLD_IDESCRIPCION_DET")).Trim()
                Dim ItemMas As String = ItemCod + " - " + ItemNom

                listaItems.AgregarRecords(ItemCod, ItemMas)

            End While

            dataBase.cerrar_Conexion()
            Return listaItems

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '----------------------------------------------------- 
    '-----------------------------------------------------
    '  Nuevo - Reporte - Inventario / InventarioXFamilia - Extrae lista de Familia de Productos.
    '-----------------------------------------------------
    Public Shared Function getListaFamilia_InveXFami() As ListaFamiliaProductos

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim listaFamiliaProductos As New ListaFamiliaProductos
        Dim TestPos As Integer

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_Busca_CODMaterial_StockEmergencia_NET2014")

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            listaFamiliaProductos.AgregarRecords("todas", "Todas")

            While lector.Read()

                Dim value_code As String = Convert.ToString(lector("MATCODIGO")).Trim

                TestPos = InStr(1, value_code, "-")

                If (TestPos = 0) Then
                    listaFamiliaProductos.AgregarRecords(value_code, value_code)
                Else
                    'codigo, divide la cadena.
                    Dim cadenas As String()
                    cadenas = value_code.Split("-")
                    listaFamiliaProductos.AgregarRecords(Convert.ToString(cadenas(0)).Trim, cadenas(0))

                End If

            End While

            dataBase.cerrar_Conexion()
            Return listaFamiliaProductos

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '----------------------------------------------------- 
    '-----------------------------------------------------
    '  Nuevo - Reporte - Despacho / DespachoXPauta  - Extrae lista de Centros de Costo.
    '-----------------------------------------------------
    Public Shared Function getListaCentroCosto() As ListaCentroC_DespaXPauta

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim listacc As New ListaCentroC_DespaXPauta

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_CENTROCOSTO_VIEW_BDG_net")

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim ccCompleto As String = Convert.ToString(lector("FLD_COMBO")).Trim
                Dim ccCodigo As String = Convert.ToString(lector("FLD_CCOCODIGO")).Trim
                Dim ccNombre As String = Convert.ToString(lector("FLD_CCONOMBRE")).Trim()
                Dim ccTipo As String = Convert.ToString(lector("FLD_CCOTIPO")).Trim()
                Dim ccCreCodigo As String = Convert.ToString(lector("FLD_CRECODIGO")).Trim()

                listacc.AgregarRecords(ccCodigo, ccNombre)

            End While

            dataBase.cerrar_Conexion()
            Return listacc

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '----------------------------------------------------- 
    '-----------------------------------------------------
    '  Nuevo - Desde Proveedores - Extraer las fechas del form de Recepcion desde Proveedores
    '-----------------------------------------------------
    Public Shared Function getListaFechasServidor_RecepDesdeProve() As Lista_FechaServidor

        Dim listafechas As New Lista_FechaServidor
        Dim dataBase As BaseDatos = getBaseDatos()

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_GEN_TRAEFECHASERVIDOR")

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()
            Dim fechaServer As String = ""
            Dim periodo As String = ""

            While lector.Read()
                fechaServer = lector("Fld_FechaActual")
                periodo = Mid(fechaServer, 7, 4)
            End While

            listafechas.AgregarRecords(fechaServer, periodo)

            dataBase.cerrar_Conexion()
            Return listafechas

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Desde Proveedores - Obtiene la lista de bodegas
    '----------------------------------------------------
    Public Shared Function getDatosBodegas(ByVal establecimiento As String)

        Dim listaBodegas As New List(Of Dictionary(Of String, String))
        Dim bodegas As New Dictionary(Of String, String)
        Dim dataBase As BaseDatos = getBaseDatos()

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_BODEGAS_CARGACOMBOxCCOSTO_net")

        comando.Parameters.Add(New SqlParameter("@FLD_ESTCODIGO", establecimiento))

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                bodegas = New Dictionary(Of String, String)
                bodegas.Add("codigo", lector("codigo"))
                bodegas.Add("nombre", lector("nombre"))

                listaBodegas.Add(bodegas)

            End While

            dataBase.cerrar_Conexion()
            Return listaBodegas

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Desde Proveedores - Obtiene el establecimiento asociado al centro de costo del usuario
    '-----------------------------------------------------
    Public Shared Function getEstablecimiento(ByVal cCosto As String)
        Dim dataBase As BaseDatos = getBaseDatos()

        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_ObtieneEstablecimientoCentroCosto")
        Dim establecimento As String = ""

        comando.Parameters.Add(New SqlParameter("@FLD_CCOCODIGO", cCosto))

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                establecimento = lector("Establecimiento")

            End While
            If establecimento <> "" Then
                dataBase.cerrar_Conexion()
                Return establecimento
            Else
                dataBase.cerrar_Conexion()
                Throw New Exception("No se encontro un establecimiento para su usuario!")
            End If

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function

    '-----------------------------------------------------
    '-----------------------------------------------------
    'Desde Proveedores - Llama al procedimento de obtencion de fecha del servidor para el periodo y al de obtencion de la orden de compra especificada
    '-----------------------------------------------------
    Public Shared Function getDatosOrdenCompra(ByVal numeroOC As String, ByVal periodo As String, ByVal usuario As UsuarioLogeado)


        If (periodo = Nothing Or periodo = "undefined" Or periodo = "") Then
            periodo = Trim(getFechaServidor.Year)
        End If

        Dim ordenCompra As New Dictionary(Of String, String)

        'If (validarBodega(periodo, numeroOC, usuario)) Then
        ordenCompra = getOrdenesCompra(periodo, numeroOC)
        If (ordenCompra.Count > 0) Then

            'dataBase.cerrar_Conexion()
            Return ordenCompra
            'End If
        Else

            'dataBase.cerrar_Conexion()

            Throw New Exception("No se encontraron datos para la orden de compra solicitada")

        End If
    End Function

    '-----------------------------------------------------
    '-----------------------------------------------------
    'Desde Proveedores - Llama al procedimento de obtencion de fecha del servidor para el periodo y al de obtencion de la orden de compra especificada
    '-----------------------------------------------------
    Public Shared Function getDatosOrdenCompraXBusRecep(ByVal nroRecepcion As String, ByVal periodo As String, ByVal usuario As UsuarioLogeado)


        If (periodo = Nothing Or periodo = "undefined" Or periodo = "") Then
            periodo = Trim(getFechaServidor.Year)
        End If

        Dim ordenCompra As New Dictionary(Of String, String)

        'If (validarBodega(periodo, numeroOC, usuario)) Then
        ordenCompra = getOrdenesCompraXBusRecep(periodo, nroRecepcion)
        If (ordenCompra.Count > 0) Then

            'dataBase.cerrar_Conexion()
            Return ordenCompra
            'End If
        Else

            'dataBase.cerrar_Conexion()

            Throw New Exception("No se encontraron datos para la orden de compra solicitada")

        End If
    End Function

    '-----------------------------------------------------
    'Desde Proveedores - Obtiene los materiales asociados a la orden de compra especificada
    '-----------------------------------------------------
    Public Shared Function getDatosMaterial(ByVal numeroOC As String, ByVal periodo As String, ByVal usuario As String)


        If (periodo = Nothing Or periodo = "undefined" Or periodo = "") Then
            periodo = Trim(getFechaServidor.Year)
        End If

        Dim listaGralMateriales As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..Pro_ObtieneOrdenesyRecepciones_net")

        comando.Parameters.Add(New SqlParameter("@Fld_PerCodigo", periodo))
        comando.Parameters.Add(New SqlParameter("@Fld_OcoNumero", numeroOC))
        comando.Parameters.Add(New SqlParameter("@FLD_USUARIO", usuario))

        Dim lector As SqlDataReader = comando.ExecuteReader()

        Try

            While lector.Read()

                Dim listaMateriales As New Dictionary(Of String, String)

                listaMateriales.Add("Fld_MatCodigo", Convert.ToString(lector("Fld_MatCodigo")))
                listaMateriales.Add("Fld_MatNombre", Convert.ToString(lector("Fld_MatNombre")))
                listaMateriales.Add("Fld_Cantidad", Convert.ToString(lector("Fld_Cantidad")))
                listaMateriales.Add("Fld_UnidMedida", Convert.ToString(lector("Fld_UnidMedida")))
                listaMateriales.Add("Fld_PrecioUnitario", Convert.ToString(lector("Fld_PrecioUnitario")))
                listaMateriales.Add("Fld_Recibido", Convert.ToString(lector("Fld_Recibido")))
                listaMateriales.Add("Fld_Entregado", Convert.ToString(lector("Fld_Entregado")))
                listaMateriales.Add("Fld_IteCodigo", Convert.ToString(lector("Fld_IteCodigo")))
                listaMateriales.Add("Fld_PPU_Neto", Convert.ToString(lector("Fld_PPU_Neto")))
                listaMateriales.Add("Fld_IVA", Convert.ToString(lector("Fld_IVA")))
                listaMateriales.Add("Fld_Impuesto", Convert.ToString(lector("Fld_Impuesto")))
                listaMateriales.Add("Fld_Porc_Impuesto", Convert.ToString(lector("Fld_Porc_Impuesto")))
                listaMateriales.Add("Fld_Porc_Iva", Convert.ToString(lector("Fld_Porc_Iva")))
                listaMateriales.Add("Fld_Total", Convert.ToString(lector("Fld_Total")))
                listaMateriales.Add("Fld_Factor", Convert.ToString(lector("Fld_Factor")))
                listaMateriales.Add("ESTADO", Convert.ToString(lector("ESTADO")))

                listaGralMateriales.Add(listaMateriales)

            End While

            dataBase.cerrar_Conexion()

            Return listaGralMateriales

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Desde Proveedores - Valida la bodega asociada al usuario en base a la de la orden de cmpra a recepcionar
    '-----------------------------------------------------
    Public Shared Function validarBodega(ByVal periodo As String, ByVal numeroOC As String, ByVal centroCosto As String) As Boolean



        If (periodo = Nothing Or periodo = "undefined" Or periodo = "") Then
            periodo = Trim(getFechaServidor.Year)
        End If
        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_ORDENESCOMPRA_BUSCAR_BODEGA_net")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
        comando.Parameters.Add(New SqlParameter("@FLD_OCONUMERO", numeroOC))

        Try
            Dim codigoBodega As String
            Dim nombreBodega As String
            Dim codigoCCosto As New String("")
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                codigoBodega = Convert.ToString(lector("codigo bodega"))
                nombreBodega = Convert.ToString(lector("nombre bodega"))
                codigoCCosto = Convert.ToString(lector("codigo"))

            End While


            If Trim(codigoCCosto).Equals(Trim(centroCosto)) Then

                dataBase.cerrar_Conexion()
                Return True
            Else

                dataBase.cerrar_Conexion()
                Return False

            End If
        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Desde Proveedores - Valida la si la OC de forma directa exise o no
    '-----------------------------------------------------
    Public Shared Function validarOC(ByVal periodo As String, ByVal numeroOC As String, ByVal centroCosto As String) As Boolean



        If (periodo = Nothing Or periodo = "undefined" Or periodo = "") Then
            periodo = Trim(getFechaServidor.Year)
        End If
        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_ORDENESCOMPRA_BUSCAR_BODEGA_net")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
        comando.Parameters.Add(New SqlParameter("@FLD_OCONUMERO", numeroOC))

        Try
            Dim codigoBodega As New String("")
            Dim nombreBodega As New String("")
            Dim codigoCCosto As New String("")
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                codigoBodega = Convert.ToString(lector("codigo bodega"))
                nombreBodega = Convert.ToString(lector("nombre bodega"))
                codigoCCosto = Convert.ToString(lector("codigo"))

            End While


            If (Trim(codigoBodega).Equals("") Or Trim(nombreBodega).Equals("")) Then

                dataBase.cerrar_Conexion()
                Return False
            Else

                dataBase.cerrar_Conexion()
                Return True

            End If
        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Desde Proveedores - Obtiene la fehca del servidor para asignacion de periodo
    '-----------------------------------------------------
    Public Shared Function getFechaServidor() As DateTime
        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_GEN_TRAEFECHASERVIDOR_net")

        Dim serverDate As DateTime
        Try

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                serverDate = lector("fecha")

            End While

            dataBase.cerrar_Conexion()

            getFechaServidor = serverDate
        Catch ex As Exception
            dataBase.cerrar_Conexion()
            Throw ex
        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Desde Proveedores - Obtiene los datos de la orden de compra especificada
    '-----------------------------------------------------
    Public Shared Function getOrdenesCompra(ByVal periodo As String, ByVal numeroOC As Integer)
        Dim dataBase As BaseDatos = getBaseDatos()

        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_ORDENESCOMPRA_SEL_net")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
        comando.Parameters.Add(New SqlParameter("@FLD_OCONUMERO", numeroOC))

        Dim lector As SqlDataReader = comando.ExecuteReader()

        Try
            Dim ordenes As New Dictionary(Of String, String)

            While lector.Read()

                ordenes.Add("FLD_OCONUMERO", Convert.ToString(lector("numero oc")))
                ordenes.Add("FLD_PERCODIGO", Convert.ToString(lector("periodo")))
                ordenes.Add("FLD_PROVEEDOR", Convert.ToString(lector("rut profesional") + "-" + lector("digito verificador") + " " + lector("razon social")))
                ordenes.Add("FLD_OCOESTADO", Convert.ToString(lector("estado oc")))
                ordenes.Add("FLD_OCPRECIO", Convert.ToString(lector("precio")))
                ordenes.Add("FLD_BODCODIGO", Convert.ToString(lector("codigo bodega")))
                ordenes.Add("FLD_BODNOMBRES", Convert.ToString(lector("nombre bodega")))
                ordenes.Add("FLD_OCODESCRIPCION", Convert.ToString(lector("descripcion")))
                ordenes.Add("numeroRecepcion", Convert.ToString(lector("numeroRecepcion")))
                ordenes.Add("tipoDocumento", Convert.ToString(lector("tipoDocumento")))
                ordenes.Add("nroDocumento", Convert.ToString(lector("nroDocumento")))
                ordenes.Add("totalRecepcionado", Convert.ToString(lector("totalRecepcionado")))
                ordenes.Add("observacionRecepcion", Convert.ToString(lector("observacionRecepcion")))
                ordenes.Add("impuestoRecepcion", Convert.ToString(lector("impuesto recepcion")))
                ordenes.Add("difPeso", Convert.ToString(lector("diferenciaPesoRecep")))
                ordenes.Add("idChileCompra", Convert.ToString(lector("idChileCompra")))
                ordenes.Add("fechaRecepcion", Convert.ToString(lector("fechaRecepcion")))
                ordenes.Add("notaCredito", Convert.ToString(lector("notaCredito")))
                ordenes.Add("descuento", Convert.ToString(lector("descuento")))

            End While

            dataBase.cerrar_Conexion()

            Return ordenes

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Desde Proveedores - Obtiene los datos de la orden de compra especificada
    '-----------------------------------------------------
    Public Shared Function getOrdenesCompraXBusRecep(ByVal periodo As String, ByVal nroRecepcion As Integer)
        Dim dataBase As BaseDatos = getBaseDatos()

        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_ORDENESCOMPRA_SEL_BUSXRECEP_net")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", nroRecepcion))

        Dim lector As SqlDataReader = comando.ExecuteReader()

        Try
            Dim ordenes As New Dictionary(Of String, String)

            While lector.Read()

                ordenes.Add("FLD_OCONUMERO", Convert.ToString(lector("numero oc")))
                ordenes.Add("FLD_PERCODIGO", Convert.ToString(lector("periodo")))
                ordenes.Add("FLD_PROVEEDOR", Convert.ToString(lector("rut profesional") + "-" + lector("digito verificador") + " " + lector("razon social")))
                ordenes.Add("FLD_OCOESTADO", Convert.ToString(lector("estado oc")))
                ordenes.Add("FLD_OCPRECIO", Convert.ToString(lector("precio")))
                ordenes.Add("FLD_BODCODIGO", Convert.ToString(lector("codigo bodega")))
                ordenes.Add("FLD_BODNOMBRES", Convert.ToString(lector("nombre bodega")))
                ordenes.Add("FLD_OCODESCRIPCION", Convert.ToString(lector("descripcion")))
                ordenes.Add("numeroRecepcion", Convert.ToString(lector("numeroRecepcion")))
                ordenes.Add("tipoDocumento", Convert.ToString(lector("tipoDocumento")))
                ordenes.Add("nroDocumento", Convert.ToString(lector("nroDocumento")))
                ordenes.Add("totalRecepcionado", Convert.ToString(lector("totalRecepcionado")))
                ordenes.Add("observacionRecepcion", Convert.ToString(lector("observacionRecepcion")))
                ordenes.Add("impuestoRecepcion", Convert.ToString(lector("impuesto recepcion")))
                ordenes.Add("difPeso", Convert.ToString(lector("diferenciaPesoRecep")))
                ordenes.Add("idChileCompra", Convert.ToString(lector("idChileCompra")))
                ordenes.Add("fechaRecepcion", Convert.ToString(lector("fechaRecepcion")))
                ordenes.Add("notaCredito", Convert.ToString(lector("notaCredito")))
                ordenes.Add("descuento", Convert.ToString(lector("descuento")))

            End While

            dataBase.cerrar_Conexion()

            Return ordenes

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Desde Proveedores - Obtiene los datos de la orden de compra especificada
    '-----------------------------------------------------
    Public Shared Function getMaterialesXBusRecep(ByVal tmvcodigo As String, ByVal nroRecepcion As Integer, ByVal periodo As String) As ListaMaterialRecepcion
        Dim dataBase As BaseDatos = getBaseDatos()

        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DETMOVIMIENTOS_SEL_ORDENCOMPRA")

        comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", tmvcodigo))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", nroRecepcion))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))

        Dim articulo As New ListaMaterialRecepcion("success", "0")

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim total As Double = 0.0
                total = Double.Parse(lector("Fld_Total").ToString)

                articulo.AgregarRecords(Convert.ToString(lector("FLD_MATCODIGO")).Trim, Convert.ToString(lector("FLD_MATNOMBRE")).Trim, lector("Fld_UnidMedida"), lector("Fld_Cantidad"),
                                          lector("FLD_PPUNETO"), lector("FLD_ITECODIGO"), total.ToString)
            End While

            dataBase.cerrar_Conexion()
            Return articulo

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Desde Proveedores - Obtiene los datos de los materiales asociados a la orden de compra especificada
    '-----------------------------------------------------
    Public Shared Function getDatosMaterialesTemporal(ByVal numeroOC As Integer)

        Dim listaGralMateriales As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_MATERIALES_TEMP_SEL_net")

        comando.Parameters.Add(New SqlParameter("@Fld_OcoNumero", numeroOC))

        Dim lector As SqlDataReader = comando.ExecuteReader()

        Try

            While lector.Read()

                Dim listaMateriales As New Dictionary(Of String, String)

                listaMateriales.Add("Fld_MatCodigo", Convert.ToString(lector("FLD_MATCODIGO")))
                listaMateriales.Add("Fld_MatNombre", Convert.ToString(lector("FLD_MATNOMBRE")))
                listaMateriales.Add("Fld_Cantidad", Convert.ToString(lector("FLD_CANTIDAD")))
                listaMateriales.Add("Fld_UnidMedida", Convert.ToString(lector("FLD_UNIDMEDIDA")))
                listaMateriales.Add("Fld_PrecioUnitario", Convert.ToString(lector("FLD_PRECIOUNITARIO")))
                listaMateriales.Add("Fld_Recibido", Convert.ToString(lector("FLD_RECIBIDO")))
                listaMateriales.Add("Fld_Entregado", Convert.ToString(lector("FLD_ENTREGADO")))
                listaMateriales.Add("Fld_IteCodigo", Convert.ToString(lector("FLD_ITECODIGO")))
                listaMateriales.Add("Fld_PPU_Neto", Convert.ToString(lector("FLD_PPUNETO")))
                listaMateriales.Add("Fld_IVA", Convert.ToString(lector("FLD_IVA")))
                listaMateriales.Add("Fld_Impuesto", Convert.ToString(lector("FLD_IMPUESTO")))
                listaMateriales.Add("Fld_Porc_Impuesto", Convert.ToString(lector("FLD_PORC_IMPUESTO")))
                listaMateriales.Add("Fld_Porc_Iva", Convert.ToString(lector("FLD_PORC_IVA")))
                listaMateriales.Add("Fld_Total", Convert.ToString(lector("FLD_TOTAL")))
                listaMateriales.Add("Fld_Factor", Convert.ToString(lector("FLD_FACTOR")))
                listaMateriales.Add("ESTADO", Convert.ToString(lector("ESTADO")))
                listaMateriales.Add("Fld_Cantidad_Temporal", Convert.ToString(lector("FLD_CANTIDAD_TEMPORAL")))
                listaMateriales.Add("Fld_RecepcionFactura", Convert.ToString(lector("FLD_FACTURA_RECEP")))

                listaGralMateriales.Add(listaMateriales)

            End While

            dataBase.cerrar_Conexion()

            Return listaGralMateriales

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Desde Proveedores - Obtiene el detalle del material seleccionado (cantidad, lote, serie, vencimiento) si no existe envia campos en cero
    '-----------------------------------------------------
    Public Shared Function getDetallesMateriales(ByVal ocoNumero As String, ByVal matCodigo As String, ByVal periodo As String, _
                                                 ByVal numeroRecepcion As String)

        Dim listaDetallesMats As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DETALLE_MATERIALES_SEL_TEMP_net")

        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", matCodigo))
        comando.Parameters.Add(New SqlParameter("@FLD_OCONUMERO", Integer.Parse(ocoNumero)))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))

        Dim lector As SqlDataReader = comando.ExecuteReader()

        Try

            While lector.Read()

                Dim detallesMateriales As New Dictionary(Of String, String)

                detallesMateriales.Add("FLD_CANTIDAD", Convert.ToString(lector("FLD_CANTIDAD")))
                detallesMateriales.Add("FLD_SERIE", Convert.ToString(lector("FLD_SERIE")))
                detallesMateriales.Add("FLD_LOTE", Convert.ToString(lector("FLD_LOTE")))
                detallesMateriales.Add("FLD_FECHAVENCIMIENTO", Convert.ToString(lector("FLD_FECHAVENCIMIENTO")))

                listaDetallesMats.Add(detallesMateriales)

            End While

            dataBase.cerrar_Conexion()

            Dim fechaServer = getFechaServidor().Date

            If (listaDetallesMats.Count <= 0) Then

                Dim detallesMateriales As New Dictionary(Of String, String)

                detallesMateriales.Add("FLD_CANTIDAD", "0")
                detallesMateriales.Add("FLD_SERIE", "0")
                detallesMateriales.Add("FLD_LOTE", "0")
                detallesMateriales.Add("FLD_FECHAVENCIMIENTO", fechaServer)

                listaDetallesMats.Add(detallesMateriales)

            End If

            Return listaDetallesMats

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Desde Proveedores - obtiene el detalle de productos ingresados para evaluar la cantidad de qr a imprimir
    '-----------------------------------------------------
    Public Shared Function getRecordsParaQR(ByVal matCodigo As String, ByVal periodo As String, _
                                                 ByVal numeroRecepcion As String)

        Dim listaDetallesMats As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_SEL_MATERIALES_RECEPCIONADOS_net2015")

        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", matCodigo))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", Integer.Parse(numeroRecepcion)))

        Dim lector As SqlDataReader = comando.ExecuteReader()

        Try

            While lector.Read()

                Dim detallesMateriales As New Dictionary(Of String, String)

                detallesMateriales.Add("FLD_MATCODIGO", Convert.ToString(lector("FLD_MATCODIGO")))
                detallesMateriales.Add("FLD_NSERIE", Convert.ToString(lector("FLD_NSERIE")))
                detallesMateriales.Add("FLD_MOVCANTIDAD", Convert.ToString(lector("FLD_MOVCANTIDAD")))

                listaDetallesMats.Add(detallesMateriales)

            End While

            dataBase.cerrar_Conexion()

            Dim fechaServer = getFechaServidor().Date

            If (listaDetallesMats.Count <= 0) Then

                Dim detallesMateriales As New Dictionary(Of String, String)

                detallesMateriales.Add("FLD_MATCODIGO", "0")
                detallesMateriales.Add("FLD_NSERIE", "0")
                detallesMateriales.Add("FLD_MOVCANTIDAD", "0")

                listaDetallesMats.Add(detallesMateriales)

            End If

            Return listaDetallesMats

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Desde Proveedores - Guarda la informacion de los detalles en la tabla temporal de la base de datos
    '-----------------------------------------------------
    Public Shared Function saveDetallesMaterialTemporal(ByVal nroOC As String, ByVal codMaterial As String, ByVal detalleMat As Dictionary(Of String, String))

        Dim dataBase As BaseDatos = getBaseDatos()

        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DETALLE_MATERIALES_INS_TEMP_net")
        Dim validate As Integer = 0

        comando.Parameters.Add(New SqlParameter("@FLD_OCONUMERO", nroOC))
        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codMaterial))
        comando.Parameters.Add(New SqlParameter("@FLD_SERIE", detalleMat("nroSerie")))
        comando.Parameters.Add(New SqlParameter("@FLD_LOTE", detalleMat("nroLote")))
        comando.Parameters.Add(New SqlParameter("@FLD_FECHAVENCIMIENTO", detalleMat("fechaVencimiento")))
        comando.Parameters.Add(New SqlParameter("@FLD_CANTIDAD", detalleMat("cantidad")))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", detalleMat("periodo")))

        Dim lector As SqlDataReader = comando.ExecuteReader()

        While lector.Read()

            validate = lector("validate")

        End While

        dataBase.cerrar_Conexion()

        Return validate

    End Function

    '-----------------------------------------------------
    '-----------------------------------------------------
    'Desde Proveedores - Actualiza el estado del facto y si fue recepcionado por factura especifica en la base de datos
    '-----------------------------------------------------
    Public Shared Function updateFactorFacturaMaterial(ByVal nroOC As String, ByVal matCodigo As String, ByVal factor As String, ByVal nroFactura As String)

        Dim validate As Integer = 0
        Dim dataBase As BaseDatos = getBaseDatos()

        ' Conectar a BD
        dataBase.Conectar_Sin_Datos()

        Try

            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_MATERIALES_UPDATE_FACTOR_FACTURA")

            comando.Parameters.Add(New SqlParameter("@FLD_FACTOR", Double.Parse(factor)))
            comando.Parameters.Add(New SqlParameter("@FLD_NROFACTURA", nroFactura))
            comando.Parameters.Add(New SqlParameter("@FLD_OCONUMERO", nroOC))
            comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", matCodigo))

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                validate = lector("validate")

            End While

            dataBase.cerrar_Conexion()
            Return validate

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Desde Proveedores - actualiza el estado de la recepcion (posible eliminacion)
    '-----------------------------------------------------
    Public Shared Function updateRecepcion(ByVal recepcion As Recepcion)

        Dim validate As Integer
        Dim dataBase As BaseDatos = getBaseDatos()

        ' Conectar a BD
        dataBase.Conectar_Sin_Datos()

        Try

            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_RECEPCIONES_UPDATE")

            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", recepcion.periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", recepcion.tipoMovimiento))
            comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", Integer.Parse(recepcion.comMovimineto)))
            comando.Parameters.Add(New SqlParameter("@FLD_NRODOC", Integer.Parse(recepcion.nroDoc)))
            comando.Parameters.Add(New SqlParameter("@FLD_TIPDOCRECEP", recepcion.tipoDocRecepcion))
            comando.Parameters.Add(New SqlParameter("@FLD_RECOBSERVACION", recepcion.obsRecepcion))
            comando.Parameters.Add(New SqlParameter("@FLD_NETO", Double.Parse(recepcion.pNeto)))
            comando.Parameters.Add(New SqlParameter("@FLD_DIFPESO", Double.Parse(recepcion.difPeso)))

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                validate = lector("validate")

            End While

            dataBase.cerrar_Conexion()
            Return validate

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Desde Proveedores - ingresa una nueva recepcion con los datos ingresados
    '-----------------------------------------------------
    Public Shared Function crearRecepcion(ByVal oconumero As String, ByVal periodo As String, ByVal tipoMovimiento As String, ByVal usuario As String,
                                          ByVal bodCodigo As String, ByVal percodigoOC As String, ByVal precioRecep As Double,
                                          ByVal nroDoc As String, ByVal tipoDocRecepcion As String, ByVal obsRecepcion As String, ByVal pNeto As Double,
                                          ByVal ivaRecep As Double, ByVal descuento As Double, ByVal impuestoRecep As Double, ByVal difPeso As String)

        Dim respuesta As New Dictionary(Of String, String)
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_RECEPCIONES_INS_ALL_net")

            comando.Parameters.Add(New SqlParameter("@FLD_OCONUMERO", oconumero))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", tipoMovimiento))
            comando.Parameters.Add(New SqlParameter("@FLD_USULOGIN", usuario))
            comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", bodCodigo))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO_OCO", percodigoOC))
            comando.Parameters.Add(New SqlParameter("@FLD_MOVPRECIO", precioRecep))
            comando.Parameters.Add(New SqlParameter("@FLD_NRODOC", nroDoc))
            comando.Parameters.Add(New SqlParameter("@FLD_TIPDOCRECEP", tipoDocRecepcion))
            comando.Parameters.Add(New SqlParameter("@FLD_RECOBSERVACION", obsRecepcion))
            comando.Parameters.Add(New SqlParameter("@FLD_NETO", pNeto))
            comando.Parameters.Add(New SqlParameter("@FLD_IVA", ivaRecep))
            comando.Parameters.Add(New SqlParameter("@FLD_DESCUENTO", descuento))
            comando.Parameters.Add(New SqlParameter("@FLD_IMPUESTO", impuestoRecep))
            comando.Parameters.Add(New SqlParameter("@FLD_DIFPESO", difPeso))

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                respuesta.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                respuesta.Add("FLD_TMVCODIGO", Convert.ToString(lector("FLD_TMVCODIGO")))
                respuesta.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                respuesta.Add("ERROR", Convert.ToString(lector("ERROR")))

            End While

            dataBase.cerrar_Conexion()

            Return respuesta

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            respuesta.Add("FLD_CMVNUMERO", "0")
            respuesta.Add("FLD_TMVCODIGO", "0")
            respuesta.Add("FLD_PERCODIGO", "0")
            respuesta.Add("ERROR", ex.Message)
            Return respuesta

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Desde Proveedores - CREA NOTA DE CREDITO
    '-----------------------------------------------------
    Public Shared Function crearNotaCredito(ByVal periodoNC As String, ByVal numeroOCNC As String, ByVal IDChileCompraNC As String,
                                            ByVal montoNC As Double, ByVal rutProvNC As String, ByVal numeroFacNC As String, ByVal fechaFactNC As DateTime,
                                            ByVal rutUserNC As String, ByVal codBodegaNC As String, ByVal fechaActualNC As DateTime,
                                            ByVal motivoNC As String)

        Dim respuesta As New Dictionary(Of String, String)
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_NOTACREDITO_INS_NEW2015")

            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodoNC))
            comando.Parameters.Add(New SqlParameter("@FLD_OCONUMERO", numeroOCNC))
            comando.Parameters.Add(New SqlParameter("@FLD_ID_CHILECOMPRA", IDChileCompraNC))
            comando.Parameters.Add(New SqlParameter("@FLD_MOVPRECIO", montoNC))
            comando.Parameters.Add(New SqlParameter("@FLD_PRORUT", rutProvNC))

            comando.Parameters.Add(New SqlParameter("@FLD_NROFACTURA", numeroFacNC))
            comando.Parameters.Add(New SqlParameter("@FLD_FECHAFACTURA", fechaFactNC))
            comando.Parameters.Add(New SqlParameter("@FLD_RUTUSER", rutUserNC))
            comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", codBodegaNC))

            comando.Parameters.Add(New SqlParameter("@FLD_FECHANOTACRE", fechaActualNC))
            comando.Parameters.Add(New SqlParameter("@FLD_DESCRIPCION", motivoNC))

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                respuesta.Add("FLD_NRONOTACRE", Convert.ToString(lector("FLD_NRONOTACRE")))
                respuesta.Add("ERROR", Convert.ToString(lector("ERROR")))

            End While

            dataBase.cerrar_Conexion()

            Return respuesta

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            respuesta.Add("FLD_NRONOTACRE", "0")
            respuesta.Add("ERROR", ex.Message)
            Return respuesta

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Desde Proveedores - elmina un detalle de material en la tabla temporal de la base de datos antes dle ingreso de la recepcion
    '-----------------------------------------------------
    Public Shared Function limpiarTemporalDetalles(ByVal nroOc As String, ByVal codMaterial As String)
        Dim dataBase As BaseDatos = getBaseDatos()

        ' Conectar a BD
        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DETALLE_MATERIALES_DELETE_TEMP_net")

        Dim validate As Integer = 0

        comando.Parameters.Add(New SqlParameter("@FLD_OCONUMERO", nroOc))
        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codMaterial))

        Dim lector As SqlDataReader = comando.ExecuteReader()

        While lector.Read()

            validate = lector("estado")

        End While

        dataBase.cerrar_Conexion()

        Return validate

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Desde Proveedores PopUp Orden de compra y recepciones - Obtiene la lista de los periodos desde la base de datos
    '-----------------------------------------------------
    Public Shared Function getListaPeriodos()
        Dim listaPeriodos As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_PERIODOS_SELL_NET")

        Dim lector As SqlDataReader = comando.ExecuteReader()

        Try

            While lector.Read()

                Dim periodo As New Dictionary(Of String, String)

                periodo.Add("percodigo", Convert.ToString(lector("percodigo")))
                periodo.Add("pernombre", Convert.ToString(lector("pernombre")))

                listaPeriodos.Add(periodo)

            End While

            dataBase.cerrar_Conexion()

            Return listaPeriodos

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    'Desde Proveedores PopUp Orden de compra y recepciones - Obtiene la lista de los Estados desde la base de datos
    '-----------------------------------------------------
    Public Shared Function getListaEstados()
        Dim listaPeriodos As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()


        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_ESTADOS_OCO_VIEW")

        Dim lector As SqlDataReader = comando.ExecuteReader()


        Try


            While lector.Read()


                Dim periodo As New Dictionary(Of String, String)


                periodo.Add("FLD_OCOESTADO", Convert.ToString(lector("FLD_OCOESTADO")))
                periodo.Add("FLD_COMBO", Convert.ToString(lector("FLD_COMBO")))

                listaPeriodos.Add(periodo)

            End While

            dataBase.cerrar_Conexion()

            Return listaPeriodos

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Desde Proveedores PopUp Orden de Compra - Obtiene la lista de los proveedores desde la base de datos
    '-----------------------------------------------------
    Public Shared Function getListaProveedores()

        Dim listaProveedores As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_PROVEEDORES_CARGACOMBO_V2")

        Dim lector As SqlDataReader = comando.ExecuteReader()

        Try

            While lector.Read()

                Dim proveedor As New Dictionary(Of String, String)

                proveedor.Add("FLD_PRORUT", Convert.ToString(lector("FLD_PRORUT")))
                proveedor.Add("PROVEEDOR", Convert.ToString(lector("PROVEEDOR")))
                proveedor.Add("FLD_PRORAZONSOC", Convert.ToString(lector("FLD_PRORAZONSOC")))

                listaProveedores.Add(proveedor)

            End While

            dataBase.cerrar_Conexion()

            Return listaProveedores

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Desde Proveedores PopUp Orden de Compra - Obtiene la lista de las ordenes de compra solicitadas en la busqueda
    '-----------------------------------------------------
    Public Shared Function getOrdenesCompraBOC(ByVal numeroOC As String, ByVal periodo As String, ByVal estado As String, _
                                               ByVal proveedor As String, ByVal chileCompra As String)

        Dim listaOrdenesCompra As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_ORDENESCOMPRA_SELALL_net")

        comando.Parameters.Add(New SqlParameter("@FLD_OCONUMERO", numeroOC))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
        comando.Parameters.Add(New SqlParameter("@FLD_OCOESTADO", estado))
        comando.Parameters.Add(New SqlParameter("@FLD_PROVEEDOR", proveedor))
        comando.Parameters.Add(New SqlParameter("@FLD_CHILECOMPRA", chileCompra))

        Dim lector As SqlDataReader = comando.ExecuteReader()

        Try

            While lector.Read()

                Dim ordenCompra As New Dictionary(Of String, String)

                ordenCompra.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                ordenCompra.Add("FLD_OCONUMERO", Convert.ToString(lector("FLD_OCONUMERO")))
                ordenCompra.Add("FLD_PRORAZONSOC", Convert.ToString(lector("FLD_PRORAZONSOC")))
                ordenCompra.Add("FLD_OCPRECIO", Convert.ToString(lector("FLD_OCPRECIO")))
                ordenCompra.Add("FLD_ID_CHILECOMPRA", Convert.ToString(lector("FLD_ID_CHILECOMPRA")))
                ordenCompra.Add("FLD_OCOESTADO", Convert.ToString(lector("FLD_OCOESTADO")))
                ordenCompra.Add("FLD_DESCRIPCION", Convert.ToString(lector("FLD_DESCRIPCION")))
                ordenCompra.Add("FLD_PRORUT", Convert.ToString(lector("FLD_PRORUT")))

                listaOrdenesCompra.Add(ordenCompra)

            End While

            dataBase.cerrar_Conexion()

            Return listaOrdenesCompra

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Desde Proveedores PopUp Recepciones - Obtiene la lista de las recepciones solicitadas en la busqueda
    '-----------------------------------------------------
    Public Shared Function getRecepcionesBRECEP(ByVal nroRecepcion As Integer, ByVal periodoRecep As String, ByVal nroOC As Integer, _
                                                ByVal periodoOC As String, ByVal estadoOC As String, ByVal tipoBusqueda As Integer)

        Dim listaOrdenesCompra As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_RECEPCIONES_SELALL_NEW2015")

        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", nroRecepcion))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO_REC", periodoRecep))
        comando.Parameters.Add(New SqlParameter("@FLD_OCONUMERO", nroOC))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO_OCO", periodoOC))
        comando.Parameters.Add(New SqlParameter("@FLD_OCOESTADO", estadoOC))
        comando.Parameters.Add(New SqlParameter("@TIPO_BUSQUEDA", tipoBusqueda))

        Dim lector As SqlDataReader = comando.ExecuteReader()

        Try

            While lector.Read()

                Dim ordenCompra As New Dictionary(Of String, String)

                ordenCompra.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                ordenCompra.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                ordenCompra.Add("FLD_RECFECHA", Convert.ToString(lector("FLD_RECFECHA")))
                ordenCompra.Add("FLD_RECDESCRIPCION", Convert.ToString(lector("FLD_RECDESCRIPCION")))
                ordenCompra.Add("FLD_PERCODIGO_OCO", Convert.ToString(lector("FLD_PERCODIGO_OCO")))
                ordenCompra.Add("FLD_OCONUMERO", Convert.ToString(lector("FLD_OCONUMERO")))
                ordenCompra.Add("FLD_PRORUT", Convert.ToString(lector("Rut")))
                ordenCompra.Add("FLD_PRORAZONSOC", Convert.ToString(lector("FLD_PRORAZONSOC")))
                ordenCompra.Add("FLD_OCOESTADO", Convert.ToString(lector("FLD_OCOESTADO")))
                ordenCompra.Add("FLD_DESCRIPCION", Convert.ToString(lector("FLD_DESCRIPCION")))

                listaOrdenesCompra.Add(ordenCompra)

            End While

            dataBase.cerrar_Conexion()

            Return listaOrdenesCompra

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    ' RECEPCIONES - OC x NroFactura - Obtiene la lista de las recepciones solicitadas en la busqueda.
    '-----------------------------------------------------
    Public Shared Function getOCxNroFactura(ByVal nroFactura As Integer, ByVal periodoRecep As String, ByVal nroOC As Integer, _
                                                ByVal periodoOC As String, ByVal estadoOC As String, ByVal tipoBusqueda As Integer)

        Dim listaOrdenesCompra As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_RECEPCIONES_SELALL_NEW2015")

        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", nroFactura))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO_REC", periodoRecep))
        comando.Parameters.Add(New SqlParameter("@FLD_OCONUMERO", nroOC))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO_OCO", periodoOC))
        comando.Parameters.Add(New SqlParameter("@FLD_OCOESTADO", estadoOC))
        comando.Parameters.Add(New SqlParameter("@TIPO_BUSQUEDA", tipoBusqueda))

        Dim lector As SqlDataReader = comando.ExecuteReader()

        Try

            While lector.Read()

                Dim ordenCompra As New Dictionary(Of String, String)

                ordenCompra.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")).Trim)
                ordenCompra.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")).Trim)
                ordenCompra.Add("FLD_RECFECHA", Convert.ToString(lector("FLD_RECFECHA")).Trim)
                ordenCompra.Add("FLD_RECDESCRIPCION", Convert.ToString(lector("FLD_RECDESCRIPCION")).Trim)
                ordenCompra.Add("FLD_PERCODIGO_OCO", Convert.ToString(lector("FLD_PERCODIGO_OCO")).Trim)
                ordenCompra.Add("FLD_OCONUMERO", Convert.ToString(lector("FLD_OCONUMERO")).Trim)
                ordenCompra.Add("FLD_PRORUT", Convert.ToString(lector("Rut")).Trim)
                ordenCompra.Add("FLD_PRORAZONSOC", Convert.ToString(lector("FLD_PRORAZONSOC")).Trim)
                ordenCompra.Add("FLD_OCOESTADO", Convert.ToString(lector("FLD_OCOESTADO")).Trim)
                ordenCompra.Add("FLD_DESCRIPCION", Convert.ToString(lector("FLD_DESCRIPCION")).Trim)

                listaOrdenesCompra.Add(ordenCompra)

            End While

            dataBase.cerrar_Conexion()

            Return listaOrdenesCompra

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'FacturasAGuia - Obtiene la lista de Guias en base a los criterioas de busqueda
    '-----------------------------------------------------
    Public Shared Function getGuiasFactura(ByVal proveedor As String, ByVal tipo As Integer, ByVal factura As Integer, ByVal percodigo As Integer, ByVal nroGuia As Integer)

        Dim listaGuiasFactura As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_Buscar_GuiasProveedor_NEW2013")

        comando.Parameters.Add(New SqlParameter("@Proveedor", proveedor))
        comando.Parameters.Add(New SqlParameter("@Tipo", tipo))
        comando.Parameters.Add(New SqlParameter("@Factura", factura))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", percodigo))
        comando.Parameters.Add(New SqlParameter("@Guia", nroGuia))

        Dim lector As SqlDataReader = comando.ExecuteReader()

        Try

            While lector.Read()

                Dim guiaFactura As New Dictionary(Of String, String)

                guiaFactura.Add("GUIA", Convert.ToString(lector("GUIA")))
                guiaFactura.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                guiaFactura.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                guiaFactura.Add("FLD_PRORUT", Convert.ToString(lector("FLD_PRORUT")))
                guiaFactura.Add("FLD_PRORAZONSOC", Convert.ToString(lector("FLD_PRORAZONSOC")))
                guiaFactura.Add("FLD_OCONUMERO", Convert.ToString(lector("FLD_OCONUMERO")))
                guiaFactura.Add("FLD_PERCODIGO_OCO", Convert.ToString(lector("FLD_PERCODIGO_OCO")))
                guiaFactura.Add("FACTURA", Convert.ToString(lector("FACTURA")))
                guiaFactura.Add("coment", Convert.ToString(lector("coment")))

                listaGuiasFactura.Add(guiaFactura)

            End While

            dataBase.cerrar_Conexion()

            Return listaGuiasFactura

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'FacturasAGuia - Obtiene la lista de Guias en base a los criterioas de busqueda
    '-----------------------------------------------------
    Public Shared Function guardarGuiasFactura(ByVal nroGuia As String, ByVal nroRecepcion As String, ByVal añorecepcion As String, ByVal nroFactura As String, ByVal rutProveedor As String)

        Dim validate As Integer = 1
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_Grabar_GUIA_FACTURA_net")

            comando.Parameters.Add(New SqlParameter("@Guia", nroGuia))
            comando.Parameters.Add(New SqlParameter("@Recepcion", nroRecepcion))
            comando.Parameters.Add(New SqlParameter("@Periodo", añorecepcion))
            comando.Parameters.Add(New SqlParameter("@Factura", nroFactura))
            comando.Parameters.Add(New SqlParameter("@Rut", rutProveedor))
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                validate = lector("validate")

            End While

            dataBase.cerrar_Conexion()

            Return validate

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'DevoluccionXNroPedido - Obtiene la lista de Despachos segun parametros dce busqueda
    '-----------------------------------------------------
    Public Shared Function getDespachosNPedido(ByVal nroDespacho As Integer, ByVal periodo As String, ByVal nroPedido As Integer, _
                                               ByVal usuario As String)

        Dim Despachos As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_DETALLE_DESPACHO_net")

            comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", nroDespacho))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_PBONUMERO", nroPedido))
            comando.Parameters.Add(New SqlParameter("@FLD_USULOGIN", usuario))
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim despacho As New Dictionary(Of String, String)

                despacho.Add("FLD_MATCODIGO", Convert.ToString(lector("FLD_MATCODIGO")))
                despacho.Add("FLD_MATNOMBRE", Convert.ToString(lector("FLD_MATNOMBRE")))
                despacho.Add("FLD_ITECODIGO", Convert.ToString(lector("FLD_ITECODIGO")))
                despacho.Add("FLD_ITEDENOMINACION", Convert.ToString(lector("FLD_ITEDENOMINACION")))
                despacho.Add("FLD_BODCODIGO", Convert.ToString(lector("FLD_BODCODIGO")))
                despacho.Add("FLD_BODNOMBRES", Convert.ToString(lector("FLD_BODNOMBRES")))
                despacho.Add("FLD_CANTPEDIDA", Convert.ToString(lector("FLD_CANTPEDIDA")))
                despacho.Add("FLD_MOVCANTIDAD", Convert.ToString(lector("FLD_MOVCANTIDAD")))
                despacho.Add("FLD_CANTADEVOLVER", Convert.ToString(lector("FLD_CANTADEVOLVER")))
                despacho.Add("FLD_PRECIOUNITARIO", Convert.ToString(lector("FLD_PRECIOUNITARIO")))
                despacho.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                despacho.Add("FLD_PBONUMERO", Convert.ToString(lector("FLD_PBONUMERO")))
                despacho.Add("FLD_FECHAVENCIMIENTO", Convert.ToString(lector("FLD_FECHAVENCIMIENTO")))
                despacho.Add("FLD_LOTE", Convert.ToString(lector("FLD_LOTE")))

                Despachos.Add(despacho)

            End While

            dataBase.cerrar_Conexion()

            Return Despachos

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'DevoluccionXNroPedido - Obtiene la lista de Despachos segun datos ingresados en PopUp
    '-----------------------------------------------------
    Public Shared Function getDespachosNPedidoPopUp(ByVal nroDespacho As Integer, ByVal periodo As String, ByVal nroPedido As Integer)

        Dim Despachos As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DESPACHOS_BODEGA_SEL_FILTER_NEW2014")

            comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", nroDespacho))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_PBONUMERO", nroPedido))
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim despacho As New Dictionary(Of String, String)

                despacho.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                despacho.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                despacho.Add("FLD_DESFECHA", Convert.ToString(lector("FLD_DESFECHA")))
                despacho.Add("FLD_DESDESCRIPCION", Convert.ToString(lector("FLD_DESDESCRIPCION")))
                despacho.Add("FLD_PBONUMERO", Convert.ToString(lector("FLD_PBONUMERO")))
                despacho.Add("FLD_CMVNUMERO_DEV", Convert.ToString(lector("FLD_CMVNUMERO_DEV")))
                despacho.Add("FLD_DEVFECHA", Convert.ToString(lector("FLD_DEVFECHA")))
                despacho.Add("FLD_DEVDESCRIPCION", Convert.ToString(lector("FLD_DEVDESCRIPCION")))

                Despachos.Add(despacho)

            End While

            dataBase.cerrar_Conexion()

            Return Despachos

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'DevoluccionXNroPedido - Obtiene la lista de Despachos segun cmvnumero
    '-----------------------------------------------------
    Public Shared Function getDetallesMaterialDevolNPedido(ByVal nroDespacho As Integer, ByVal periodo As String, ByVal numeroPedido As Integer, _
                                                           ByVal codigoMaterial As String, ByVal usuario As String, ByVal fechaVencimientoAnte As String, _
                                                          ByVal loteSerie_Anterior As String)

        Dim detallesMaterial As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_DET_MATERIALES_DEVOL_NPEDIDO_SEL_NEW2014")

            comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", nroDespacho))
            comando.Parameters.Add(New SqlParameter("@FLD_PBONUMERO", numeroPedido))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codigoMaterial))
            comando.Parameters.Add(New SqlParameter("@FLD_USULOGIN", usuario))
            comando.Parameters.Add(New SqlParameter("@FLD_LOTESERIE_DESPACHO", fechaVencimientoAnte))
            comando.Parameters.Add(New SqlParameter("@FLD_FECHAVENCIMIENTO_DESPACHO", loteSerie_Anterior))
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim Detalle As New Dictionary(Of String, String)

                Detalle.Add("FLD_MATCODIGO", Convert.ToString(lector("FLD_MATCODIGO")))
                Detalle.Add("FLD_MOVCANTIDAD", Convert.ToString(lector("FLD_MOVCANTIDAD")))
                Detalle.Add("FLD_LOTE", Convert.ToString(lector("FLD_LOTE")))
                Detalle.Add("FLD_FECHAVENCIMIENTO", Convert.ToString(lector("FLD_FECHAVENCIMIENTO")))

                detallesMaterial.Add(Detalle)

            End While

            dataBase.cerrar_Conexion()

            Return detallesMaterial

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'DevoluccionXNroPedido - guarda los detalles del material especificado
    '-----------------------------------------------------
    Public Shared Function saveDetalleMaterialDevNPedido(ByVal nroDespacho As Integer, ByVal periodo As String, ByVal nroPedido As Integer, _
                                                          ByVal codigoMaterial As String, ByVal loteSerie As String, ByVal cantidad As Integer, _
                                                          ByVal fechaVencimineto As String, ByVal usuario As String, ByVal loteSerieAnte_det As String, _
                                                          ByVal fechaVencimientoAnte As String, ByVal loteSerie_Anterior As String)
        Dim validate As Integer = 0
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_DET_MATERIALES_DEVOL_NPEDIDO_INS_NEW2014")

            comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", nroDespacho))
            comando.Parameters.Add(New SqlParameter("@FLD_PBONUMERO", nroPedido))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codigoMaterial))
            comando.Parameters.Add(New SqlParameter("@FLD_LOTESERIE", loteSerie))
            comando.Parameters.Add(New SqlParameter("@FLD_CANTIDAD", cantidad))
            comando.Parameters.Add(New SqlParameter("@FLD_FECHAVENCIMIENTO", fechaVencimineto))
            comando.Parameters.Add(New SqlParameter("@FLD_USULOGIN", usuario))
            comando.Parameters.Add(New SqlParameter("@FLD_LOTESERIE_ANTEDET", loteSerieAnte_det))
            comando.Parameters.Add(New SqlParameter("@FLD_LOTESERIE_DESPACHO", loteSerie_Anterior))
            comando.Parameters.Add(New SqlParameter("@FLD_FECHAVENCIMIENTO_DESPACHO", fechaVencimientoAnte))
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()


                validate = lector("Validate")


            End While

            dataBase.cerrar_Conexion()

            Return validate

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'DevoluccionXNroPedido - Actuliza los datos de los materiales en la BD para la generacion de la devolucion
    '-----------------------------------------------------
    Public Shared Function actualizaEstadoMaterialDevolucion(ByVal nroDespacho As Integer, ByVal periodo As String, ByVal nroPedido As Integer, _
                                                          ByVal codigoMaterial As String, ByVal cantidadARecibir As Integer, ByVal usuario As String, _
                                                          ByVal loteSerie As String, ByVal fechaVencimiento As String)
        Dim validate As Integer = 0
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_ACTUALIZA_ESTADO_TB_MATS_TEMP_DEVNPEDIDO_NEW2014")

            comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", nroDespacho))
            comando.Parameters.Add(New SqlParameter("@FLD_PBONUMERO", nroPedido))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codigoMaterial))
            comando.Parameters.Add(New SqlParameter("@FLD_CANTIDAD", cantidadARecibir))
            comando.Parameters.Add(New SqlParameter("@FLD_USULOGIN", usuario))
            comando.Parameters.Add(New SqlParameter("@FLD_LOTESERIE_DESPACHO", loteSerie))
            comando.Parameters.Add(New SqlParameter("@FLD_FECHAVENCIMIENTO_DESPACHO", fechaVencimiento))
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()


                validate = lector("Validate")


            End While

            dataBase.cerrar_Conexion()

            Return validate

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'DevoluccionXNroPedido - guarda los detalles del material especificado
    '-----------------------------------------------------
    Public Shared Function generaDevolucionXNPedido(ByVal usuario As String, ByVal descripcion As String, ByVal periodo As String, _
                                                    ByVal cmvNumero As Integer, ByVal nroDespacho As Integer)

        Dim respuesta As New Dictionary(Of String, String)
        Dim dataBase As BaseDatos = getBaseDatos()
        Dim perido_Server As String = getFechaServidor().Year
        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_GENERA_DEVOLUCION_NPEDIDO_net")

            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", perido_Server))
            comando.Parameters.Add(New SqlParameter("@FLD_USULOGIN", usuario))
            comando.Parameters.Add(New SqlParameter("@FLD_DEVDESCRIPCION", descripcion))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO_DESPACHO", periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO_DESPACHO", cmvNumero))
            comando.Parameters.Add(New SqlParameter("@FLD_PBONUMERO_DESPACHO", nroDespacho))
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                respuesta.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                respuesta.Add("FLD_TMVCODIGO", Convert.ToString(lector("FLD_TMVCODIGO")))
                respuesta.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                respuesta.Add("ERROR", Convert.ToString(lector("ERROR")))

            End While

            dataBase.cerrar_Conexion()

            Return respuesta

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            respuesta.Add("FLD_CMVNUMERO", "0")
            respuesta.Add("FLD_TMVCODIGO", "0")
            respuesta.Add("FLD_PERCODIGO", "0")
            respuesta.Add("ERROR", ex.Message)
            Return respuesta

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Devolucion de Usuarios - Obtiene Lista de bodegas para devolucion de usuarios
    '-----------------------------------------------------
    Public Shared Function getlistaBodegasDevUsuarios(ByVal establecimiento As String)

        Dim listaBodegas As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_BODEGAS_CARGACOMBOxCCOSTO_net")

            comando.Parameters.Add(New SqlParameter("@FLD_ESTCODIGO", establecimiento))
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim Bodega As New Dictionary(Of String, String)

                Bodega.Add("BodCodigo", Convert.ToString(lector("codigo")))
                Bodega.Add("BodNombre", Convert.ToString(lector("nombre")))

                listaBodegas.Add(Bodega)

            End While

            dataBase.cerrar_Conexion()

            Return listaBodegas

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Devolucion de Usuarios - Obtiene Centro Costo de Usuario en devolucion x usuario
    '-----------------------------------------------------
    Public Shared Function getListaCentrosCostosDevUsu(ByVal codCentroCosto As String)

        Dim listaCentrosCosto As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_CENTROCOSTO_COMBOBOX_SEL_net")

            comando.Parameters.Add(New SqlParameter("@FLD_CCOCODIGO", "Todos"))
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim centroDeCosto As New Dictionary(Of String, String)

                centroDeCosto.Add("FLD_CCOCODIGO", Convert.ToString(lector("FLD_CCOCODIGO")))
                centroDeCosto.Add("FLD_CCONOMBRE", Convert.ToString(lector("FLD_CCONOMBRE")))

                listaCentrosCosto.Add(centroDeCosto)

            End While

            dataBase.cerrar_Conexion()

            Return listaCentrosCosto

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Devolucion de Usuarios - Obtiene lista de materiales para PopUp de devolucion x usuarios
    '-----------------------------------------------------
    Public Shared Function getListaMaterialesDevXUsuariosPUp(ByVal nombreMaterial As String, ByVal codigoBodega As String, ByVal codigoMaterial As String)

        Dim listaMateriales As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_BUSCAMATERIALES_DEVOLUSUARIOS_net")

            comando.Parameters.Add(New SqlParameter("@FLD_MATNOMBRE", nombreMaterial))
            comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", codigoBodega))
            comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codigoMaterial))
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim material As New Dictionary(Of String, String)

                material.Add("FLD_MATCODIGO", Convert.ToString(lector("FLD_MATCODIGO")))
                material.Add("FLD_MATNOMBRE", Convert.ToString(lector("FLD_MATNOMBRE")))
                material.Add("FLD_EXIPRECIOUNITARIO", Convert.ToString(lector("FLD_EXIPRECIOUNITARIO")))
                material.Add("FLD_ITECODIGO", Convert.ToString(lector("FLD_ITECODIGO")))
                material.Add("FLD_EXICANTIDAD", Convert.ToString(lector("FLD_EXICANTIDAD")))
                material.Add("FLD_ITEDENOMINACION", Convert.ToString(lector("FLD_ITEDENOMINACION")))
                material.Add("FLD_UMEDDESCRIPCION", Convert.ToString(lector("FLD_UMEDDESCRIPCION")))
                material.Add("FLD_BODCODIGO", Convert.ToString(lector("FLD_BODCODIGO")))
                material.Add("FLD_FECHAVENCIMIENTO", Convert.ToString(lector("FLD_FECHAVENCIMIENTO")))

                listaMateriales.Add(material)

            End While

            dataBase.cerrar_Conexion()

            Return listaMateriales

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Devolucion de Usuarios - Obtiene lista de devoluciones para PopUp de devolucion x usuarios
    '-----------------------------------------------------
    Public Shared Function getListaDevolucionesUsuarioPopUp(ByVal perCodigo As String, ByVal nroPedido As String)

        Dim listaDevoluciones As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TBBUSCARDEVOLUCIONXUSUARIOS_net")

            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", perCodigo))
            comando.Parameters.Add(New SqlParameter("@FLD_PBONUMERO", nroPedido))
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim devolucion As New Dictionary(Of String, String)

                devolucion.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                devolucion.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                devolucion.Add("FLD_BODCODIGO", Convert.ToString(lector("FLD_BODCODIGO")))
                devolucion.Add("FLD_USULOGIN", Convert.ToString(lector("FLD_USULOGIN")))
                devolucion.Add("FLD_DEVDESCRIPCION", Convert.ToString(lector("FLD_DEVDESCRIPCION")))
                devolucion.Add("FLD_CCOCODIGO", Convert.ToString(lector("FLD_CCOCODIGO")))
                devolucion.Add("FLD_DEVFECHA", Convert.ToString(lector("FLD_DEVFECHA")))

                listaDevoluciones.Add(devolucion)

            End While

            dataBase.cerrar_Conexion()

            Return listaDevoluciones

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Devolucion de Usuarios - Obtiene lista de materiales para devolución de Seleccionada
    '-----------------------------------------------------
    Public Shared Function getListaMaterialesDevolucion(ByVal perCodigo As String, ByVal nroPedido As String, ByVal usuario As String)

        Dim listaMateriales As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TBMATERIALESDEVOLUCIONUSUSARIOS_SEL_net")

            comando.Parameters.Add(New SqlParameter("@FLD_PBONUMERO", nroPedido))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", perCodigo))
            comando.Parameters.Add(New SqlParameter("@FLD_USERNAME", usuario))

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim material As New Dictionary(Of String, String)

                material.Add("FLD_MATCODIGO", Convert.ToString(lector("FLD_MATCODIGO")))
                material.Add("FLD_ITECODIGO", Convert.ToString(lector("FLD_ITECODIGO")))
                material.Add("FLD_CANTADEVOLVER", Convert.ToString(lector("FLD_CANTADEVOLVER")))
                material.Add("FLD_PRECIOUNITARIO", Convert.ToString(lector("FLD_PRECIOUNITARIO")))
                material.Add("FLD_MATNOMBRE", Convert.ToString(lector("FLD_MATNOMBRE")))
                material.Add("FLD_UMEDDESCRIPCION", Convert.ToString(lector("FLD_UMEDDESCRIPCION")))
                material.Add("FLD_LOTE", Convert.ToString(lector("FLD_LOTE")))
                material.Add("FLD_FECHAVENCIMIENTO", Convert.ToString(lector("FLD_FECHAVENCIMIENTO")))

                listaMateriales.Add(material)

            End While

            dataBase.cerrar_Conexion()

            Return listaMateriales

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Devolucion de Usuarios - GUARDA LOS MATERIALES DE LA DEVOLUCION DE USUSARIO
    '-----------------------------------------------------
    Public Shared Function saveMaterialesDevolucionUsuario(ByVal perCodigo As String, ByVal usuario As String, ByVal codMaterial As String, _
                                                           ByVal cantidad As Integer, ByVal loteSerie As String, ByVal fechaVenc As String, _
                                                           ByVal precioUnitario As Double)

        Dim respuesta As New Dictionary(Of String, String)
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TBMATERIALESDEVOLUCIONUSUARIO_TEMP_INS_NEW2014")

            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", perCodigo))
            comando.Parameters.Add(New SqlParameter("@FLD_USERNAME", usuario))
            comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codMaterial))
            comando.Parameters.Add(New SqlParameter("@FLD_CANTIDAD", cantidad))
            comando.Parameters.Add(New SqlParameter("@FLD_LOTESERIE", loteSerie))
            comando.Parameters.Add(New SqlParameter("@FLD_FECHAVENCIMIENTO", fechaVenc))
            comando.Parameters.Add(New SqlParameter("@FLD_PRECIOUNITARIO", precioUnitario))

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                'respuesta.Add("ERROR", Convert.ToString(lector("ERROR")))
                respuesta.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                respuesta.Add("ERROR", Convert.ToString(lector("ERROR")))

            End While

            dataBase.cerrar_Conexion()

            Return respuesta

        Catch ex As Exception

            'dataBase.cerrar_Conexion()
            'Return 1
            dataBase.cerrar_Conexion()
            respuesta.Add("FLD_CMVNUMERO", "0")
            respuesta.Add("ERROR", ex.Message)
            Return respuesta

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Devolucion de Usuarios - GENERA LA DEVOLUCION DE USUSARIO
    '-----------------------------------------------------
    Public Shared Function generaDevolucionUsuarios(ByVal perCodigo As String, ByVal usuario As String, ByVal observacion As String, _
                                                    ByVal centroCosto As String, ByVal codBodega As String, ByVal cmvNumero As String)

        Dim respuesta As New Dictionary(Of String, String)
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DEVOLUCIONESUSUSARIO_GENERDEVOLUCION_net")

            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", perCodigo))
            comando.Parameters.Add(New SqlParameter("@FLD_USULOGIN", usuario))
            comando.Parameters.Add(New SqlParameter("@FLD_DEVDESCRIPCION", observacion))
            comando.Parameters.Add(New SqlParameter("@FLD_CCOCODIGO", centroCosto))
            comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", codBodega))
            comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", cmvNumero))

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                respuesta.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                respuesta.Add("FLD_TMVCODIGO", Convert.ToString(lector("FLD_TMVCODIGO")))
                respuesta.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                respuesta.Add("ERROR", Convert.ToString(lector("ERROR")))

            End While

            dataBase.cerrar_Conexion()

            Return respuesta

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            respuesta.Add("FLD_CMVNUMERO", "0")
            respuesta.Add("ERROR", ex.Message)
            Return respuesta
        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Devolucion de Usuarios - ACTUALIZA LA DEVOLUCION DE USUSARIO
    '-----------------------------------------------------
    Public Shared Function actualizaDevolucionXNPedido(ByVal perCodigo As String, ByVal observacion As String, ByVal cmvNumero As String)

        Dim respuesta As New Dictionary(Of String, String)
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DEVOLUCIONES_ACTUALIZADESCRIPCIONDEVOLUCION_NEW2014")

            comando.Parameters.Add(New SqlParameter("@CMVNUMERO", cmvNumero))
            comando.Parameters.Add(New SqlParameter("@PERCODIGO", perCodigo))
            comando.Parameters.Add(New SqlParameter("@OBSERVACIONDEV", observacion))

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                respuesta.Add("ERROR", Convert.ToString(lector("ERROR")))
                respuesta.Add("FLD_DEVDESCRIPCION", Convert.ToString(lector("FLD_DEVDESCRIPCION")))

            End While

            dataBase.cerrar_Conexion()

            Return respuesta

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            respuesta.Add("ERROR", ex.Message)
            Return respuesta
        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Despacho a Usuarios - Obtiene Datos de despacho hacia usuarios
    '-----------------------------------------------------
    Public Shared Function getDatosPedidoAUsuarios(ByVal periodo As String, ByVal nroPedido As Integer)

        Dim PedidoBodega As New Dictionary(Of String, String)
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_PEDIDOSBODEGA_SEL_net")

            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_PBONUMERO", nroPedido))
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                PedidoBodega.Add("FLD_PBONUMERO", Convert.ToString(lector("FLD_PBONUMERO")))
                PedidoBodega.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                PedidoBodega.Add("FLD_BODCODIGO", Convert.ToString(lector("FLD_BODCODIGO")))
                PedidoBodega.Add("FLD_BODNOMBRES", Convert.ToString(lector("FLD_BODNOMBRES")))
                PedidoBodega.Add("FLD_PBOESTADO", Convert.ToString(lector("FLD_PBOESTADO")))
                PedidoBodega.Add("FLD_CCOCODIGO", Convert.ToString(lector("FLD_CCOCODIGO")))
                PedidoBodega.Add("FLD_PBOTIPO", Convert.ToString(lector("FLD_PBOTIPO")))
                PedidoBodega.Add("FLD_OBSERVACION", Convert.ToString(lector("FLD_OBSERVACION")))
                PedidoBodega.Add("FLD_CMVNUMERODESPACHO", Convert.ToString(lector("FLD_CMVNUMERODESPACHO")))
                PedidoBodega.Add("FLD_DESFECHA", Convert.ToString(lector("FLD_DESFECHA")))
            End While

            dataBase.cerrar_Conexion()

            Return PedidoBodega

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    ' Despacho a Usuarios - Obtiene el detalle de los articulos cuando es solicitado.
    '-----------------------------------------------------
    Public Shared Function BuscaDetalleMaterial_Despa_HaciaUsuarios(ByVal Ncorrelativo As Integer, ByVal fecha As String, ByVal CodMaterial As String) As ListaDetalleArticulos

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..pro_Busca_DetalleMateriales_AUsuarios_new2015")

        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", Ncorrelativo))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))
        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", CodMaterial))

        Dim retorno As New ListaDetalleArticulos()

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                retorno.AgregarRecords(i, Convert.ToString(lector("FLD_MOVNUMEROLINEA")).Trim, Convert.ToString(lector("FLD_TMVCODIGO")).Trim,
                                       lector("FLD_PERCODIGO"), lector("FLD_CMVNUMERO"), Convert.ToString(lector("FLD_MATCODIGO")).Trim, lector("FLD_MOVCANTIDAD"),
                                       Convert.ToString(lector("FLD_NSERIE")).Trim, lector("FLD_FECHAVENCIMIENTO"))
                i = i + 1

            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Despacho a Usuarios - Obtiene Lista Materiales de pedido
    '-----------------------------------------------------
    Public Shared Function getMaterialesPedidoBodega(ByVal periodo As String, ByVal nroPedido As Integer, ByVal bodCodigo As String, ByVal numeroDespacho As String)

        Dim ListaMaterialesPedido As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DESPACHOS_SELMAT_net")

            comando.Parameters.Add(New SqlParameter("@FLD_PBONUMERO", nroPedido))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", bodCodigo))
            comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", numeroDespacho))
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim materialPedido As New Dictionary(Of String, String)

                materialPedido.Add("FLD_MATCODIGO", Convert.ToString(lector("FLD_MATCODIGO")))
                materialPedido.Add("FLD_MATNOMBRE", Convert.ToString(lector("FLD_MATNOMBRE")))
                materialPedido.Add("FLD_ITECODIGO", Convert.ToString(lector("FLD_ITECODIGO")))
                materialPedido.Add("FLD_ITEDENOMINACION", Convert.ToString(lector("FLD_ITEDENOMINACION")))
                materialPedido.Add("FLD_CANTPEDIDA", Convert.ToString(lector("FLD_CANTPEDIDA")))
                materialPedido.Add("FLD_MOVCANTIDAD", Convert.ToString(lector("FLD_MOVCANTIDAD")))
                materialPedido.Add("FLD_CANTPENDIENTE", Convert.ToString(lector("FLD_CANTPENDIENTE")))
                materialPedido.Add("FLD_EXICANTIDAD", Convert.ToString(lector("FLD_EXICANTIDAD")))
                materialPedido.Add("FLD_EXIPRECIOUNITARIO", Convert.ToString(lector("FLD_PRECIOUNITARIO")))
                materialPedido.Add("FLD_ADESPACHAR", Convert.ToString(lector("FLD_ADESPACHAR")))
                materialPedido.Add("FLD_TOTAL", Convert.ToString(lector("FLD_TOTAL")))
                materialPedido.Add("FLD_PAUTA", Convert.ToString(lector("FLD_PAUTA")))

                ListaMaterialesPedido.Add(materialPedido)

            End While

            dataBase.cerrar_Conexion()

            Return ListaMaterialesPedido

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Despacho a Usuarios - Obtiene Lista de Detalles Material de despacho usuarios
    '-----------------------------------------------------
    Public Shared Function getDetalleMaterialPedidoBodega(ByVal nroPedido As Integer, ByVal bodCodigo As String, ByVal codigoMaterial As String)

        Dim ListaDetallesMaterialPedido As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_BUSCA_DETALLE_MATERIALES_DespOInt_NET2014")

            comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codigoMaterial))
            comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", bodCodigo))
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim detalleMaterialPedido As New Dictionary(Of String, String)

                detalleMaterialPedido.Add("FLD_MOVNUMEROLINEA", Convert.ToString(lector("FLD_MOVNUMEROLINEA")))
                detalleMaterialPedido.Add("FLD_TMVCODIGO", Convert.ToString(lector("FLD_TMVCODIGO")))
                detalleMaterialPedido.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                detalleMaterialPedido.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                detalleMaterialPedido.Add("FLD_CANTIDAD", Convert.ToString(lector("FLD_MOVCANTIDAD")))
                detalleMaterialPedido.Add("FLD_MATCODIGO", Convert.ToString(lector("FLD_MATCODIGO")))
                detalleMaterialPedido.Add("FLD_LOTESERIE", Convert.ToString(lector("FLD_NSERIE")))
                detalleMaterialPedido.Add("FLD_FECHAVENCIMIENTO", Convert.ToString(lector("FLD_FECHAVENCIMIENTO")))
                detalleMaterialPedido.Add("FLD_PBONUMERO", Convert.ToString(nroPedido))

                ListaDetallesMaterialPedido.Add(detalleMaterialPedido)

            End While

            dataBase.cerrar_Conexion()

            Return ListaDetallesMaterialPedido

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Despacho a Usuarios - Obtiene el correlativo para el save.
    '-----------------------------------------------------
    Public Shared Function getCorrelativo_AUsuario(ByVal fecha As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..pro_GeneraCorrelativo_DespachHaciaUsuarios")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))

        Dim donacionArticulo As New Dictionary(Of String, String)

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            If (lector.Read()) Then
                donacionArticulo.Add("Correlativo", Convert.ToString(lector("Correlativo")).Trim)
            Else
                donacionArticulo.Add("item", "null")
            End If

            dataBase.cerrar_Conexion()
            Return donacionArticulo

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Despacho a Usuarios - GUARDA Lista de Detalles Material de despacho usuarios
    '-----------------------------------------------------
    Public Shared Function saveDetalleMaterialDespUsuario(ByVal nroPedido As Integer, ByVal periodo As String, ByVal numeroDespacho As Integer, _
                                                          ByVal codigoMaterial As String, ByVal cantidad As Integer, ByVal loteSerie As String, _
                                                          ByVal fechaVencimiento As String, ByVal bodega As String, ByVal cmvNumero As Integer)

        Dim dataBase As BaseDatos = getBaseDatos()
        'Dim validate As Integer = 0
        Dim validate As New Dictionary(Of String, String)

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            'Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DETALLES_MAT_DESPACHOUSU_INS_NEW2014")
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DETALLES_MAT_DESPACHOUSU_INS_NEW2015")

            comando.Parameters.Add(New SqlParameter("@FLD_PBONUMERO", nroPedido))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", numeroDespacho))
            comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codigoMaterial))
            comando.Parameters.Add(New SqlParameter("@FLD_CANTIDAD", cantidad))
            comando.Parameters.Add(New SqlParameter("@FLD_LOTESERIE", loteSerie))
            'comando.Parameters.Add(New SqlParameter("@FLD_LOTESERIE_ANT", loteSerieAnt))
            comando.Parameters.Add(New SqlParameter("@FLD_FECHAVENCIMIENTO", fechaVencimiento))
            comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", bodega))
            comando.Parameters.Add(New SqlParameter("@FLD_MOVNUMEROLINEA", cmvNumero))

            Dim lector As SqlDataReader = comando.ExecuteReader()

            'While lector.Read()
            '    validate = lector("validate")
            'End While

            'dataBase.cerrar_Conexion()
            'Return validate
            While lector.Read()

                If (lector("ERROR") = 0) Then
                    validate.Add("ERROR", Convert.ToString(lector("ERROR")))
                Else
                    validate.Add("ERROR", Convert.ToString(lector("ERROR")))
                    validate.Add("MENSAJE", Convert.ToString(lector("MENSAJE")))
                End If

            End While

            dataBase.cerrar_Conexion()

            Return validate

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            validate.Add("ERROR", "1")
            validate.Add("MENSAJE", ex.Message)
            Return validate

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Despacho a Usuarios - GUARDA Lista de MaterialES despacho usuarios
    '-----------------------------------------------------
    Public Shared Function updateMaterialesDespachoUsuarios(ByVal nroPedido As Integer, ByVal periodo As String, ByVal numeroDespacho As Integer, _
                                                          ByVal codigoMaterial As String, ByVal cantidad As Integer, ByVal total As String)

        Dim validate As New Dictionary(Of String, String)
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_ACTUALIZA_CANT_TOTAL_MATERIALES_DESPUSU_net")

            comando.Parameters.Add(New SqlParameter("@FLD_PBONUMERO", nroPedido))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", numeroDespacho))
            comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codigoMaterial))
            comando.Parameters.Add(New SqlParameter("@FLD_CANTIDAD", cantidad))
            comando.Parameters.Add(New SqlParameter("@TOTAL", total))

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                validate.Add("validate", Convert.ToString(lector("validate")))
                validate.Add("error", Convert.ToString(lector("Error")))

            End While

            dataBase.cerrar_Conexion()

            Return validate

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return validate

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Despacho a Usuarios - Obtiene Lista de ESTADOS DE PEDIDOS DE BODEGA
    '-----------------------------------------------------
    Public Shared Function getEstadoPedidosBodega()

        Dim listaEstados As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_ESTADOS_PEDIDOSBODEGA_VIEW_net")

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim estadoPedido As New Dictionary(Of String, String)

                estadoPedido.Add("FLD_COMBO", Convert.ToString(lector("FLD_COMBO")))
                estadoPedido.Add("FLD_PBOESTADO", Convert.ToString(lector("FLD_PBOESTADO")))
                estadoPedido.Add("FLD_DESCRIPCION", Convert.ToString(lector("FLD_DESCRIPCION")))

                listaEstados.Add(estadoPedido)

            End While

            dataBase.cerrar_Conexion()

            Return listaEstados

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Despacho a Usuarios - Obtiene Lista de centros de costos
    '-----------------------------------------------------
    Public Shared Function getCentrosCosto()

        Dim listaCentroCosto As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_CENTROCOSTO_VIEW_BDG_net")

        Dim lector As SqlDataReader = comando.ExecuteReader()

        Try

            While lector.Read()

                Dim centroCosto As New Dictionary(Of String, String)

                centroCosto.Add("FLD_COMBO", Convert.ToString(lector("FLD_COMBO")))
                centroCosto.Add("FLD_CCOCODIGO", Convert.ToString(lector("FLD_CCOCODIGO")))
                centroCosto.Add("FLD_CCONOMBRE", Convert.ToString(lector("FLD_CCONOMBRE")))

                listaCentroCosto.Add(centroCosto)

            End While

            dataBase.cerrar_Conexion()

            Return listaCentroCosto

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Despacho a Usuarios - Obtiene Lista de pedidos de Bodegas
    '-----------------------------------------------------
    Public Shared Function getListaPedidosBodega()

        Dim listaPedidosBodega As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_PEDIDOSBODEGA_VIEW_net")

        Dim lector As SqlDataReader = comando.ExecuteReader()

        Try

            While lector.Read()

                Dim pedidoBodega As New Dictionary(Of String, String)

                pedidoBodega.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                pedidoBodega.Add("FLD_PBONUMERO", Convert.ToString(lector("FLD_PBONUMERO")))
                pedidoBodega.Add("FLD_PBOESTADO", Convert.ToString(lector("FLD_PBOESTADO")))
                pedidoBodega.Add("FLD_ESTADOPEDIDO", Convert.ToString(lector("FLD_ESTADOPEDIDO")))
                pedidoBodega.Add("FLD_CCOCODIGO", Convert.ToString(lector("FLD_CCOCODIGO")))
                pedidoBodega.Add("FLD_CCOSTONUMERO", Convert.ToString(lector("FLD_CCOSTONUMERO")))
                pedidoBodega.Add("FLD_PBOTIPO", Convert.ToString(lector("FLD_PBOTIPO")))
                pedidoBodega.Add("FLD_PBOTIPONUMERO", Convert.ToString(lector("FLD_PBOTIPONUMERO")))
                pedidoBodega.Add("SOL_A", Convert.ToString(lector("SOL_A")))
                pedidoBodega.Add("FLD_OBSERVACION", Convert.ToString(lector("FLD_OBSERVACION")))

                listaPedidosBodega.Add(pedidoBodega)

            End While

            dataBase.cerrar_Conexion()

            Return listaPedidosBodega

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Despacho a Usuarios - Genera el Despacho a usuarios con la informacion correspondiente
    '-----------------------------------------------------
    Public Shared Function generaDespachoAUsuarios(ByVal nroPedido As Integer, ByVal usuario As String, ByVal descripcionDesp As String, ByVal periodo As String, ByVal numeroDespacho As Integer, _
                                                          ByVal codigoBodega As String)

        Dim validate As New Dictionary(Of String, String)
        Dim peridoDespacho As String = getFechaServidor().Year.ToString
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_GENERA_DESPACHO_net")

            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", peridoDespacho.Trim()))
            comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", numeroDespacho))
            comando.Parameters.Add(New SqlParameter("@FLD_USUARIO", usuario))
            comando.Parameters.Add(New SqlParameter("@FLD_DESDESCRIPCION", descripcionDesp))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO_PBO", periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_PBONUMERO", nroPedido))
            comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", codigoBodega))

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                validate.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                validate.Add("FLD_TMVCODIGO", Convert.ToString(lector("FLD_TMVCODIGO")))
                validate.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                validate.Add("FLD_DESFECHA", Convert.ToString(lector("FLD_DESFECHA")))
                validate.Add("FLD_PBOESTADO", Convert.ToString(lector("FLD_PBOESTADO")))
                validate.Add("ERROR", Convert.ToString(lector("ERROR")))

            End While

            dataBase.cerrar_Conexion()

            Return validate

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            validate.Add("FLD_CMVNUMERO", "0")
            validate.Add("ERROR", ex.Message)
            Return validate

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Modificacion de Despachos - Obtiene Lista de despachos para modificación de despachos
    '-----------------------------------------------------
    Public Shared Function getListaDespachosModDespachos(ByVal periodoDesp As String, ByVal nroDespacho As String, ByVal limite As Integer, _
                                                         ByVal limiteInf As Integer)

        Dim listaDespachos As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DESPACHOS_BODEGA_SEL_LIMITE_NEW2014")

        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", nroDespacho))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodoDesp))
        comando.Parameters.Add(New SqlParameter("@LIMITE", limite))
        comando.Parameters.Add(New SqlParameter("@LIMITEINF", limiteInf))

        Dim lector As SqlDataReader = comando.ExecuteReader()

        Try

            While lector.Read()

                Dim despacho As New Dictionary(Of String, String)

                despacho.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                despacho.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                despacho.Add("FLD_DESFECHA", Convert.ToString(lector("FLD_DESFECHA")))
                despacho.Add("FLD_DESDESCRIPCION", Convert.ToString(lector("FLD_DESDESCRIPCION")))
                despacho.Add("FLD_PBONUMERO", Convert.ToString(lector("FLD_PBONUMERO")))
                despacho.Add("TOTAL", Convert.ToString(lector("TOTAL")))
                despacho.Add("RNumber", Convert.ToString(lector("RN")))
                despacho.Add("error", "0")

                listaDespachos.Add(despacho)

            End While

            dataBase.cerrar_Conexion()

            Return listaDespachos

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Dim errorEx As New Dictionary(Of String, String)
            errorEx.Add("error", "Se presento el siguiente error: " & ex.Message)
            listaDespachos.Add(errorEx)
            Return listaDespachos

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Modificacion de Despachos - actualiza la descripcion del despacho especificado
    '-----------------------------------------------------
    Public Shared Function actualizaDescripcionDespacho(ByVal periodo As String, ByVal numeroDespacho As Integer, ByVal descripcionDesp As String)

        Dim validate As New Dictionary(Of String, String)
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_ACTUALIZA_DESPACHO_net")

            comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", numeroDespacho))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_DESDESCRIPCION", descripcionDesp))

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                validate.Add("ERROR", Convert.ToString(lector("ERROR")))

            End While

            dataBase.cerrar_Conexion()

            Return validate

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            validate.Add("ERROR", ex.Message)
            Return validate

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Despacho por Transferencia - Obtiene Lista de transferencias de Bodegas
    '-----------------------------------------------------
    Public Shared Function getListaTransferencias(ByVal nroPedido As Integer, ByVal periodoTransf As Integer, ByVal estadoTransf As String)

        Dim listaTransferencias As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        dataBase.Conectar_Sin_Datos()

        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_PEDIDOSTRANSFERENCIA_VIEW_NET2015")
        'Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_TRASPASOS_DEV_SELALL_net")

        comando.Parameters.Add(New SqlParameter("@FLD_PBONUMERO", nroPedido))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodoTransf))
        comando.Parameters.Add(New SqlParameter("@FLD_PBOESTADO", estadoTransf))

        Dim lector As SqlDataReader = comando.ExecuteReader()

        Try

            While lector.Read()

                Dim transferencia As New Dictionary(Of String, String)

                transferencia.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                transferencia.Add("FLD_PBONUMERO", Convert.ToString(lector("FLD_PBONUMERO")))
                transferencia.Add("FLD_PBOESTADO", Convert.ToString(lector("FLD_PBOESTADO")))
                transferencia.Add("FLD_PBOTIPO", Convert.ToString(lector("FLD_PBOTIPO")))
                transferencia.Add("SOL_A", Convert.ToString(lector("SOL_A")))
                transferencia.Add("FLD_BODORIGEN", Convert.ToString(lector("FLD_BODORIGEN")))
                transferencia.Add("FLD_BODDESTINO", Convert.ToString(lector("FLD_BODDESTINO")))

                listaTransferencias.Add(transferencia)

            End While

            dataBase.cerrar_Conexion()

            Return listaTransferencias

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    ' Despacho por Transferencia - Obtiene el detalle de los articulos cuando es solicitado.
    '-----------------------------------------------------
    Public Shared Function BuscaDetalleMaterial_Despa_Transferencia(ByVal Ncorrelativo As Integer, ByVal fecha As String, ByVal CodMaterial As String) As ListaDetalleArticulos

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..pro_Busca_DetalleMateriales_DespachoTransferencia_new2015")

        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", Ncorrelativo))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))
        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", CodMaterial))

        Dim retorno As New ListaDetalleArticulos()

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                retorno.AgregarRecords(i, Convert.ToString(lector("FLD_MOVNUMEROLINEA")).Trim, Convert.ToString(lector("FLD_TMVCODIGO")).Trim,
                                       lector("FLD_PERCODIGO"), lector("FLD_CMVNUMERO"), Convert.ToString(lector("FLD_MATCODIGO")).Trim, lector("FLD_MOVCANTIDAD"),
                                       Convert.ToString(lector("FLD_NSERIE")).Trim, lector("FLD_FECHAVENCIMIENTO"))
                i = i + 1

            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

        'Try
        '    Dim lector As SqlDataReader = comando.ExecuteReader()

        '    If (lector.Read()) Then
        '        donacionArticulo.Add("Tabla", Convert.ToString(lector("Tabla")).Trim)
        '    Else
        '        donacionArticulo.Add("item", "null")
        '    End If

        '    dataBase.cerrar_Conexion()
        '    Return donacionArticulo

        'Catch ex As Exception

        '    dataBase.cerrar_Conexion()
        '    Throw ex

        'End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Despacho por Transferencia - Obtiene Datos de Despacho por Transferencia especificado
    '-----------------------------------------------------
    Public Shared Function getDatosDespachoXTransferencia(ByVal periodo As String, ByVal nroPedido As String)

        Dim PedidoTransferencia As New Dictionary(Of String, String)
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_PEDIDOSBODEGATRANSFERENCIA_SEL_net")

            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_PBONUMERO", nroPedido))
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                PedidoTransferencia.Add("FLD_PBONUMERO", Convert.ToString(lector("FLD_PBONUMERO")))
                PedidoTransferencia.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                PedidoTransferencia.Add("FLD_BODORIGEN", Convert.ToString(lector("FLD_BODORIGEN")))
                PedidoTransferencia.Add("FLD_BODNOMBRESORI", Convert.ToString(lector("FLD_BODNOMBRESORI")))
                PedidoTransferencia.Add("FLD_BODDESTINO", Convert.ToString(lector("FLD_BODDESTINO")))
                PedidoTransferencia.Add("FLD_BODNOMBRESDES", Convert.ToString(lector("FLD_BODNOMBRESDES")))
                PedidoTransferencia.Add("FLD_PBOESTADO", Convert.ToString(lector("FLD_PBOESTADO")))
                PedidoTransferencia.Add("FLD_PBOTIPO", Convert.ToString(lector("FLD_PBOTIPO")))
                PedidoTransferencia.Add("FLD_OBSERVACION", Convert.ToString(lector("FLD_OBSERVACION")))
                PedidoTransferencia.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                PedidoTransferencia.Add("FLD_PERPEDIDO", Convert.ToString(lector("FLD_PERPEDIDO")))
            End While

            dataBase.cerrar_Conexion()

            Return PedidoTransferencia

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    '  Nuevo - Despacho - Transferencia - Obtiene el correlativo para el save.
    '-----------------------------------------------------
    Public Shared Function getCorrelativoDespachoTransferencia(ByVal fecha As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..pro_GeneraCorrelativo_DespachoTransferencia")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))

        Dim donacionArticulo As New Dictionary(Of String, String)

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            If (lector.Read()) Then
                donacionArticulo.Add("Correlativo", Convert.ToString(lector("Correlativo")).Trim)
            Else
                donacionArticulo.Add("item", "null")
            End If

            dataBase.cerrar_Conexion()
            Return donacionArticulo

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Despacho por Transferencia - Obtiene lista de materiales de Transferencia Especificada ------------------------------------------------------------------------------------
    '-----------------------------------------------------
    Public Shared Function getListaMaterialesTransfer(ByVal nroPedido As Integer, ByVal periodo As Integer, ByVal codBodegaDespacha As String, _
                                                      ByVal codBodegaSolicita As String, ByVal usuario As String)

        Dim listaMaterialesTranf As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DESPACHOSTRANSFERENCIAS_SEL_MAT_net")

            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_PBONUMERO", nroPedido))
            comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", codBodegaDespacha))
            comando.Parameters.Add(New SqlParameter("@FLD_BODDESTINO", codBodegaSolicita))
            comando.Parameters.Add(New SqlParameter("@FLD_USERNAME", usuario))
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()
                Dim material As New Dictionary(Of String, String)

                If (lector("ERROR") = 1) Then
                    material.Add("ERROR", Convert.ToString(lector("ERROR")))
                    material.Add("MENSAJE", Convert.ToString(lector("MENSAJE")))
                    listaMaterialesTranf.Add(material)
                    Exit While
                Else
                    material.Add("FLD_MATCODIGO", Convert.ToString(lector("FLD_MATCODIGO")))
                    material.Add("FLD_MATNOMBRE", Convert.ToString(lector("FLD_MATNOMBRE")))
                    material.Add("FLD_ITECODIGO", Convert.ToString(lector("FLD_ITECODIGO")))
                    material.Add("FLD_ITEDENOMINACION", Convert.ToString(lector("FLD_ITEDENOMINACION")))
                    material.Add("FLD_MOVCANTIDAD", Convert.ToString(lector("FLD_CANTADEVOLVER")))
                    material.Add("FLD_CANTPEDIDA", Convert.ToString(lector("FLD_CANTPEDIDA")))
                    material.Add("FLD_CANTPENDIENTE", Convert.ToString(lector("FLD_CANTPENDIENTE")))
                    material.Add("FLD_EXISBODDESP", Convert.ToString(lector("FLD_EXISBODDESP")))
                    material.Add("FLD_EXIPRECIOUNITARIO", Convert.ToString(lector("FLD_PRECIOUNITARIO")))
                    material.Add("FLD_EXISBODRECI", Convert.ToString(lector("FLD_EXISBODRECI")))
                    material.Add("FLD_TOTAL", Convert.ToString(lector("FLD_TOTAL")))
                    material.Add("ERROR", Convert.ToString(lector("ERROR")))

                    listaMaterialesTranf.Add(material)
                End If

            End While

            dataBase.cerrar_Conexion()

            Return listaMaterialesTranf

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Despacho por Transferencia - Obtiene lista de materiales de Transferencia Especificada
    '-----------------------------------------------------
    Public Shared Function getDetalleMaterial(ByVal codBodegaDespacha As String, ByVal codigoMaterial As String)

        Dim listaDetallesMatsTranf As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_BUSCA_DETALLE_MATERIALES_DespOInt_NET2014")

            comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codigoMaterial))
            comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", codBodegaDespacha))
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim detalleMaterialPedido As New Dictionary(Of String, String)

                detalleMaterialPedido.Add("FLD_MOVNUMEROLINEA", Convert.ToString(lector("FLD_MOVNUMEROLINEA")))
                detalleMaterialPedido.Add("FLD_TMVCODIGO", Convert.ToString(lector("FLD_TMVCODIGO")))
                detalleMaterialPedido.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                detalleMaterialPedido.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                detalleMaterialPedido.Add("FLD_CANTIDAD", Convert.ToString(lector("FLD_MOVCANTIDAD")))
                detalleMaterialPedido.Add("FLD_MATCODIGO", Convert.ToString(lector("FLD_MATCODIGO")))
                detalleMaterialPedido.Add("FLD_LOTESERIE", Convert.ToString(lector("FLD_NSERIE")))
                detalleMaterialPedido.Add("FLD_FECHAVENCIMIENTO", Convert.ToString(lector("FLD_FECHAVENCIMIENTO")).Substring(0, 10))

                listaDetallesMatsTranf.Add(detalleMaterialPedido)
            End While

            dataBase.cerrar_Conexion()

            Return listaDetallesMatsTranf

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Despacho por Transferencia - guarda el detalle de cada material en la transferencia
    '-----------------------------------------------------
    Public Shared Function saveDetalleMaterialDespTransf(ByVal nroPedido As Integer, ByVal periodo As String, _
                                                          ByVal codigoMaterial As String, ByVal loteSerie As String, ByVal cantidad As Integer, _
                                                          ByVal fechaVencimineto As String, ByVal usuario As String, ByVal numeroLinea As Integer, _
                                                          ByVal tmvCodigo As String, ByVal percodigoDetmov As String, ByVal cmvNumero As Integer)

        Dim validate As New Dictionary(Of String, String)
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_DET_MATERIALES_DESP_TRANSFERECIAS_INS_net")

            comando.Parameters.Add(New SqlParameter("@FLD_PBONUMERO", nroPedido))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codigoMaterial))
            comando.Parameters.Add(New SqlParameter("@FLD_LOTESERIE", loteSerie))
            comando.Parameters.Add(New SqlParameter("@FLD_CANTIDAD", cantidad))
            comando.Parameters.Add(New SqlParameter("@FLD_FECHAVENCIMIENTO", fechaVencimineto))
            comando.Parameters.Add(New SqlParameter("@FLD_USULOGIN", usuario))
            comando.Parameters.Add(New SqlParameter("@FLD_MOVNUMEROLINEA", numeroLinea))
            comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", tmvCodigo))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO_DETMOV", percodigoDetmov))
            comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", cmvNumero))
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                If (lector("ERROR") = 0) Then
                    validate.Add("ERROR", Convert.ToString(lector("ERROR")))
                Else
                    validate.Add("ERROR", Convert.ToString(lector("ERROR")))
                    validate.Add("MENSAJE", Convert.ToString(lector("MENSAJE")))
                End If

            End While

            dataBase.cerrar_Conexion()

            Return validate

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            validate.Add("ERROR", "1")
            validate.Add("MENSAJE", ex.Message)
            Return validate

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Despacho por Transferencia - guarda el detalle de cada material en la transferencia
    '-----------------------------------------------------
    Public Shared Function generaDespachoTrasferencia(ByVal nroPedido As Integer, ByVal periodo As String, ByVal descripcion As String, _
                                                      ByVal codigoBodegaRecibe As String, ByVal codigoBodegaDespacha As String, _
                                                      ByVal periodoPedido As String, ByVal usuario As String, ByVal NumTransferencia As Integer)
        Dim validate As New Dictionary(Of String, String)
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            'Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_TRASPASOSTRANSFERENCIA_INS_net")
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_TRASPASOSTRANSFERENCIA_INS_new2015")

            comando.Parameters.Add(New SqlParameter("@FLD_PBONUMERO", nroPedido))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_TRADESCRIPCION", descripcion))
            comando.Parameters.Add(New SqlParameter("@FLD_BODABONO", codigoBodegaRecibe))
            comando.Parameters.Add(New SqlParameter("@FLD_BODCARGO", codigoBodegaDespacha))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGOT", periodoPedido))
            comando.Parameters.Add(New SqlParameter("@USERNAME", usuario))
            comando.Parameters.Add(New SqlParameter("@NUMTRANSFERENCIA", NumTransferencia))

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                If (lector("ERROR") = 0) Then
                    validate.Add("ERROR", Convert.ToString(lector("ERROR")))
                    validate.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                    validate.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                    validate.Add("FLD_PBOESTADO", Convert.ToString(lector("FLD_PBOESTADO")))
                    validate.Add("FLD_TMVCODIGO", Convert.ToString(lector("FLD_TMVCODIGO")))
                Else
                    validate.Add("ERROR", Convert.ToString(lector("ERROR")))
                    validate.Add("MENSAJE", Convert.ToString(lector("MENSAJE")))
                End If

            End While

            dataBase.cerrar_Conexion()

            Return validate

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            validate.Add("ERROR", "1")
            validate.Add("MENSAJE", ex.Message)
            Return validate

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'REPORTES::TRANSFERENCIAS ENTRE BODEGAS::OBTIENE LA LISTA DE ESTABLECIMIENTOS 
    '-----------------------------------------------------
    Public Shared Function getListaEstablecimientos()

        Dim listaEstablecimientos As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_ESTABLECIMIENTOS_SELLALL_net")

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim establecimiento As New Dictionary(Of String, String)

                establecimiento.Add("codigoEstab", Convert.ToString(lector("FLD_ESTCODIGO")))
                establecimiento.Add("nombreEstab", Convert.ToString(lector("Establecimientos")))

                listaEstablecimientos.Add(establecimiento)

            End While

            dataBase.cerrar_Conexion()

            Return listaEstablecimientos

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Despacho - Devolucion por Transferencia - Obtiene Datos del Despacho por Transferencia para su devolución.
    '-----------------------------------------------------
    Public Shared Function getDatosDevolucionXTransferencia(ByVal periodo As String, ByVal nroPedido As String)

        Dim PedidoTransferencia As New Dictionary(Of String, String)
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            'Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_PEDIDOSBODEGATRANSFERENCIA_SEL_net") ' para transferencia
            'Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_TRASPASOS_DEV_SEL")   -- del sistema antiguo
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_TRASPASOS_DEV_SEL_new2015")

            comando.Parameters.Add(New SqlParameter("@FLD_TRANUMERO", nroPedido))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                PedidoTransferencia.Add("FLD_TRANUMERO", Convert.ToString(lector("FLD_TRANUMERO")))
                PedidoTransferencia.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                PedidoTransferencia.Add("FLD_BODORIGEN", Convert.ToString(lector("FLD_BODORIGEN")))
                PedidoTransferencia.Add("FLD_BODNOMBRESORI", Convert.ToString(lector("FLD_BODNOMBRESORI")))
                PedidoTransferencia.Add("FLD_BODDESTINO", Convert.ToString(lector("FLD_BODDESTINO")))
                PedidoTransferencia.Add("FLD_BODNOMBRESDES", Convert.ToString(lector("FLD_BODNOMBRESDES")))
                PedidoTransferencia.Add("FLD_PBOESTADO", Convert.ToString(lector("FLD_PBOESTADO")))
                PedidoTransferencia.Add("FLD_PBOTIPO", Convert.ToString(lector("FLD_PBOTIPO")))
                PedidoTransferencia.Add("FLD_OBSERVACION", Convert.ToString(lector("FLD_OBSERVACION")))
                PedidoTransferencia.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                PedidoTransferencia.Add("FLD_PERPEDIDO", Convert.ToString(lector("FLD_PERPEDIDO")))
                PedidoTransferencia.Add("FLD_AUTORIZADO", Convert.ToString(lector("FLD_AUTORIZADO")))
                PedidoTransferencia.Add("FLD_PBONUMERO", Convert.ToString(lector("FLD_PBONUMERO")))

            End While

            dataBase.cerrar_Conexion()

            Return PedidoTransferencia

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    ' Despacho - Devolucion por Transferencia - Obtiene Lista de movimientos de transferencias entre Bodegas
    '-----------------------------------------------------
    Public Shared Function getListaTransferenciasRealizadas(ByVal nroPedido As Integer, ByVal periodoTransf As String)

        Dim listaTransferencias As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        dataBase.Conectar_Sin_Datos()

        'Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_PEDIDOSTRANSFERENCIA_VIEW_NET2015")  ' mov de transferencia original
        'Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_TRASPASOS_DEV_SELALL_net")
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_TRASPASOS_DEV_SELALL_new2015")

        comando.Parameters.Add(New SqlParameter("@FLD_TRANUMERO", nroPedido))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodoTransf))

        Dim lector As SqlDataReader = comando.ExecuteReader()

        Try

            While lector.Read()

                Dim transferencia As New Dictionary(Of String, String)

                transferencia.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                transferencia.Add("FLD_TRANUMERO", Convert.ToString(lector("FLD_TRANUMERO")))
                transferencia.Add("FLD_TRAFECHA", Convert.ToString(lector("FLD_TRAFECHA")))
                transferencia.Add("FLD_PBOTIPO", Convert.ToString(lector("FLD_PBOTIPO")))
                transferencia.Add("FLD_BODORIGEN", Convert.ToString(lector("FLD_BODORIGEN")))
                transferencia.Add("FLD_BODDESTINO", Convert.ToString(lector("FLD_BODDESTINO")))
                transferencia.Add("FLD_PBONUMERO", Convert.ToString(lector("FLD_PBONUMERO")))
                transferencia.Add("FLD_PERPEDIDO", Convert.ToString(lector("FLD_PERPEDIDO")))

                listaTransferencias.Add(transferencia)

            End While

            dataBase.cerrar_Conexion()

            Return listaTransferencias

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    ' Despacho - Devolucion por Transferencia - Obtiene el correlativo para el save.
    '-----------------------------------------------------
    Public Shared Function getCorrelativoDevolucionTransferencia(ByVal fecha As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..pro_GeneraCorrelativo_DevolucionTransferencia")

        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fecha))

        Dim donacionArticulo As New Dictionary(Of String, String)

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            If (lector.Read()) Then
                donacionArticulo.Add("Correlativo", Convert.ToString(lector("Correlativo")).Trim)
            Else
                donacionArticulo.Add("item", "null")
            End If

            dataBase.cerrar_Conexion()
            Return donacionArticulo

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try
    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    ' Despacho - Devolucion por Transferencia - Obtiene el detalle de los articulos cuando es solicitado.
    '-----------------------------------------------------
    Public Shared Function BuscaDetalleMaterial_Devo_Transferencia(ByVal NDevTranf As Integer, ByVal fechaDevTranf As String, ByVal CodMaterial As String, ByVal nroTransf As Integer, ByVal periodoTransf As String) As ListaDetalleArticulos

        Dim dataBase As BaseDatos = getBaseDatos()
        dataBase.Conectar_Sin_Datos()
        Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..pro_Busca_DetalleMateriales_DevoTransferencia_new2015")

        comando.Parameters.Add(New SqlParameter("@FLD_PBONUMERO", nroTransf))
        comando.Parameters.Add(New SqlParameter("@FLD_PERTRANSF", periodoTransf))
        comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", CodMaterial))
        comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", NDevTranf))
        comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", fechaDevTranf))

        Dim retorno As New ListaDetalleArticulos()

        Dim i As Integer = 1

        Try
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                retorno.AgregarRecords(i, Convert.ToString(lector("FLD_MOVNUMEROLINEA")).Trim, Convert.ToString(lector("FLD_TMVCODIGO")).Trim,
                                       lector("FLD_PERCODIGO"), lector("FLD_CMVNUMERO"), Convert.ToString(lector("FLD_MATCODIGO")).Trim, lector("FLD_MOVCANTIDAD"),
                                       Convert.ToString(lector("FLD_NSERIE")).Trim, lector("FLD_FECHAVENCIMIENTO"))
                i = i + 1

            End While

            dataBase.cerrar_Conexion()
            Return retorno

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Throw ex

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    ' Despacho - Devolucion por Transferencia - Obtiene lista de materiales de Transferencia Especificada ------------------------------------------------------------------------------------
    '-----------------------------------------------------
    Public Shared Function getListaMaterialesDevoTransfer(ByVal nroTransf As Integer, ByVal periodo As Integer, ByVal codBodegaDespacha As String, _
                                                      ByVal codBodegaSolicita As String, ByVal usuario As String, ByVal nroPedido As Integer, ByVal nroDevoTransf As Integer, _
                                                      ByVal periodoDevoTransf As Integer)

        Dim listaMaterialesTranf As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD 
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DEVOLUCION_TRANSFERENCIAS_SEL_MAT_net")

            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_PBONUMERO", nroPedido))           ' Nº Mov Transferencia, solicitud de pedido
            comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", codBodegaDespacha))
            comando.Parameters.Add(New SqlParameter("@FLD_BODDESTINO", codBodegaSolicita))
            comando.Parameters.Add(New SqlParameter("@FLD_USERNAME", usuario))
            comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", nroTransf))           'Nº Transferencia, una vez realizada la transferencia entre bodega
            comando.Parameters.Add(New SqlParameter("@FLD_NRODEVOTRANF", nroDevoTransf))    'Nº despues de realizada la transferencia
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGODEVOTRANF", periodoDevoTransf))

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()
                Dim material As New Dictionary(Of String, String)

                If (lector("ERROR") = 1) Then
                    material.Add("ERROR", Convert.ToString(lector("ERROR")))
                    material.Add("MENSAJE", Convert.ToString(lector("MENSAJE")))
                    listaMaterialesTranf.Add(material)
                    Exit While
                Else
                    material.Add("FLD_MATCODIGO", Convert.ToString(lector("FLD_MATCODIGO")))
                    material.Add("FLD_MATNOMBRE", Convert.ToString(lector("FLD_MATNOMBRE")))
                    material.Add("FLD_ITECODIGO", Convert.ToString(lector("FLD_ITECODIGO")))
                    material.Add("FLD_ITEDENOMINACION", Convert.ToString(lector("FLD_ITEDENOMINACION")))
                    material.Add("FLD_MOVCANTIDAD", Convert.ToString(lector("FLD_CANTADEVOLVER")))
                    material.Add("FLD_CANTPEDIDA", Convert.ToString(lector("FLD_CANTPEDIDA")))
                    material.Add("FLD_CANTPENDIENTE", Convert.ToString(lector("FLD_CANTPENDIENTE")))
                    material.Add("FLD_EXISBODDESP", Convert.ToString(lector("FLD_EXISBODDESP")))
                    material.Add("FLD_EXIPRECIOUNITARIO", Convert.ToString(lector("FLD_PRECIOUNITARIO")))
                    material.Add("FLD_EXISBODRECI", Convert.ToString(lector("FLD_EXISBODRECI")))
                    material.Add("FLD_TOTAL", Convert.ToString(lector("FLD_TOTAL")))
                    material.Add("ERROR", Convert.ToString(lector("ERROR")))

                    listaMaterialesTranf.Add(material)
                End If

            End While

            dataBase.cerrar_Conexion()

            Return listaMaterialesTranf

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    ' Despacho - Devolucion por Transferencia - guarda el detalle de cada material en la transferencia
    '-----------------------------------------------------
    Public Shared Function genera_DevolucionXTrasferencia(ByVal nroPedido As Integer, ByVal periodo As String, ByVal descripcion As String, _
                                                      ByVal codigoBodegaRecibe As String, ByVal codigoBodegaDespacha As String, _
                                                      ByVal periodoPedido As String, ByVal usuario As String, ByVal NumTransferencia As Integer)

        Dim validate As New Dictionary(Of String, String)
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DEVOLUCIONTRANSFERENCIA_INS_new2015")

            comando.Parameters.Add(New SqlParameter("@FLD_TRANUMERO", nroPedido))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodoPedido))
            comando.Parameters.Add(New SqlParameter("@FLD_TRADESCRIPCION", descripcion))
            comando.Parameters.Add(New SqlParameter("@FLD_BODABONO", codigoBodegaRecibe))
            comando.Parameters.Add(New SqlParameter("@FLD_BODCARGO", codigoBodegaDespacha))
            comando.Parameters.Add(New SqlParameter("@FLD_TRANUMERO_DEV", NumTransferencia))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGOT", periodo))

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                If (lector("ERROR") = 0) Then
                    validate.Add("ERROR", Convert.ToString(lector("ERROR")))
                    validate.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                    validate.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                Else
                    validate.Add("ERROR", Convert.ToString(lector("ERROR")))
                    validate.Add("MENSAJE", Convert.ToString(lector("MENSAJE")))
                End If

            End While

            dataBase.cerrar_Conexion()

            Return validate

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            validate.Add("ERROR", "1")
            validate.Add("MENSAJE", ex.Message)
            Return validate

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    ' Despacho - Devolucion por Transferencia - Autoriza y guarda la transacción.
    '-----------------------------------------------------
    Public Shared Function genera_DevolucionTrasferencia(ByVal nroPedido As Integer, ByVal periodo As String, ByVal user As String)

        Dim validate As New Dictionary(Of String, String)
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_DEVOLUCIONTRANSFERENCIA_ATORIZAR_DET_INS_new2015")

            comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", nroPedido))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_USER", user))

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                If (lector("ERROR") = 0) Then
                    validate.Add("ERROR", Convert.ToString(lector("ERROR")))
                    validate.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                    validate.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                    validate.Add("FLD_TMVCODIGO", Convert.ToString(lector("FLD_TMVCODIGO")))
                Else
                    validate.Add("ERROR", Convert.ToString(lector("ERROR")))
                    validate.Add("MENSAJE", Convert.ToString(lector("MENSAJE")))
                End If

            End While

            dataBase.cerrar_Conexion()

            Return validate

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            validate.Add("ERROR", "1")
            validate.Add("MENSAJE", ex.Message)
            Return validate

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'REPORTES::DESPACHO A USUARIOS::OBTIENE LA LISTA DE CENTROS DE RESPONSABILIDAD
    '-----------------------------------------------------
    Public Shared Function getCentrosResponsabilidad()

        Dim listaCentrosRespon As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_CENTROSRESPONSABILIDAD_SELALL")

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim CentroRespons As New Dictionary(Of String, String)

                CentroRespons.Add("FLD_CRECODIGO", Convert.ToString(lector("FLD_CRECODIGO")))
                CentroRespons.Add("FLD_CRENOMBRE", Convert.ToString(lector("FLD_CRENOMBRE")))

                listaCentrosRespon.Add(CentroRespons)

            End While

            dataBase.cerrar_Conexion()

            Return listaCentrosRespon

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'REPORTES::DESPACHO A USUARIOS::OBTIENE LA LISTA DE MATERIALES PARA SELECTBOX
    '-----------------------------------------------------
    Public Shared Function getListaMateriales()

        Dim listaMateriales As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_MATERIALES_BINCARD_NET2014")

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim material As New Dictionary(Of String, String)

                material.Add("COD_MATERIAL", Convert.ToString(lector("COD_MATERIAL")))
                material.Add("NOMBRE_MATERIAL", Convert.ToString(lector("NOMBRE_MATERIAL")))

                listaMateriales.Add(material)

            End While

            dataBase.cerrar_Conexion()

            Return listaMateriales

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'REPORTES::DESPACHO A USUARIOS::OBTIENE LA LISTA DE itemsPresupuestarios
    '-----------------------------------------------------
    Public Shared Function getItemsPresupuestarios()

        Dim listaItemsPresup As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_ITEMSPRESUPUESTARIOS_CARGACOMBO")

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim ItemPresup As New Dictionary(Of String, String)

                ItemPresup.Add("FLD_ITECODIGO", Convert.ToString(lector("FLD_ITECODIGO")))
                ItemPresup.Add("FLD_ITEDENOMINACION", Convert.ToString(lector("FLD_ITEDENOMINACION")))

                listaItemsPresup.Add(ItemPresup)

            End While

            dataBase.cerrar_Conexion()

            Return listaItemsPresup

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'RECEPCION CENABAST - Obtiene lista de materiales para PopUp de RECEPCION POR CENABAST
    '-----------------------------------------------------
    Public Shared Function getListaMatsRecepcionCenabastPUp(ByVal nombreMaterial As String, ByVal codigoCenabast As String, _
                                                            ByVal codigoMaterial As String, ByVal codigoBodega As String)

        Dim listaMateriales As New List(Of Dictionary(Of String, String))
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_BUSCAMATERIALES_RECEPCENABAST_net")

            comando.Parameters.Add(New SqlParameter("@FLD_MATNOMBRE", nombreMaterial))
            comando.Parameters.Add(New SqlParameter("@FLD_CODIGOCENABAST", codigoCenabast))
            comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", codigoBodega))
            comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codigoMaterial))
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                Dim material As New Dictionary(Of String, String)

                material.Add("FLD_MATCODIGO", Convert.ToString(lector("FLD_MATCODIGO")))
                material.Add("FLD_MATNOMBRE", Convert.ToString(lector("FLD_MATNOMBRE")))
                material.Add("CODIGO_CENABAST", Convert.ToString(lector("CODIGO_CENABAST")))
                material.Add("FLD_EXIPRECIOUNITARIO", Convert.ToString(lector("FLD_EXIPRECIOUNITARIO")))
                material.Add("FLD_ITECODIGO", Convert.ToString(lector("FLD_ITECODIGO")))
                material.Add("FLD_EXICANTIDAD", Convert.ToString(lector("FLD_EXICANTIDAD")))
                material.Add("FLD_ITEDENOMINACION", Convert.ToString(lector("FLD_ITEDENOMINACION")))
                material.Add("FLD_UMEDDESCRIPCION", Convert.ToString(lector("FLD_UMEDDESCRIPCION")))
                material.Add("FLD_BODCODIGO", Convert.ToString(lector("FLD_BODCODIGO")))
                material.Add("FLD_FECHAVENCIMIENTO", Convert.ToString(lector("FLD_FECHAVENCIMIENTO")))

                listaMateriales.Add(material)

            End While

            dataBase.cerrar_Conexion()

            Return listaMateriales

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'RECEPCION CENABAST - GUARDA LOS MATERIALES DE LA RECEPCION POR CENABAST
    '-----------------------------------------------------
    Public Shared Function saveMaterialesRecepCenabast(ByVal perCodigo As String, ByVal usuario As String, ByVal codMaterial As String, _
                                                       ByVal cantidad As Integer, ByVal loteSerie As String, ByVal fechaVenc As String, _
                                                       ByVal precioUnitario As Double)

        Dim respuesta As New Dictionary(Of String, String)
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TBMATERIALES_RECEPCIONCENABAST_TEMP_INS_NEW2014")

            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", perCodigo))
            comando.Parameters.Add(New SqlParameter("@FLD_USERNAME", usuario))
            comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codMaterial))
            comando.Parameters.Add(New SqlParameter("@FLD_CANTIDAD", cantidad))
            comando.Parameters.Add(New SqlParameter("@FLD_LOTESERIE", loteSerie))
            comando.Parameters.Add(New SqlParameter("@FLD_FECHAVENCIMIENTO", fechaVenc))
            comando.Parameters.Add(New SqlParameter("@FLD_PRECIOUNITARIO", precioUnitario))

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                respuesta.Add("ERROR", Convert.ToString(lector("ERROR")))

            End While

            dataBase.cerrar_Conexion()

            Return respuesta

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            Return 1

        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'RECEPCION CENABAST - GENERA LA RECEPCION POR CENABAST
    '-----------------------------------------------------
    Public Shared Function generaRecepcionCenabast(ByVal perCodigo As String, ByVal usuario As String, ByVal observacion As String, _
                                                         ByVal centroCosto As String, ByVal codBodega As String)

        Dim respuesta As New Dictionary(Of String, String)
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_GENERA_RECEPCIONXCENABAST_net")

            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", perCodigo))
            comando.Parameters.Add(New SqlParameter("@FLD_OCODESCRIPCION", observacion))
            comando.Parameters.Add(New SqlParameter("@FLD_OCOPRECIO", observacion))
            comando.Parameters.Add(New SqlParameter("@FLD_USULOGIN", usuario))
            comando.Parameters.Add(New SqlParameter("@FLD_CCOCODIGO", centroCosto))
            comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", codBodega))
            comando.Parameters.Add(New SqlParameter("@FLD_ID_CHILECOMPRA", codBodega))
            comando.Parameters.Add(New SqlParameter("@FLD_FACTURA_CENEBAST", codBodega))
            comando.Parameters.Add(New SqlParameter("@FLD_NRODOC", codBodega))
            comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", codBodega))
            comando.Parameters.Add(New SqlParameter("@FLD_PRORUT", codBodega))
            comando.Parameters.Add(New SqlParameter("@FLD_IMPUESTO", codBodega))
            comando.Parameters.Add(New SqlParameter("@FLD_EXENTO", codBodega))
            comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", codBodega))

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                respuesta.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                respuesta.Add("FLD_TMVCODIGO", Convert.ToString(lector("FLD_TMVCODIGO")))
                respuesta.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                respuesta.Add("ERROR", Convert.ToString(lector("ERROR")))

            End While

            dataBase.cerrar_Conexion()

            Return respuesta

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            respuesta.Add("FLD_CMVNUMERO", "0")
            respuesta.Add("ERROR", ex.Message)
            Return respuesta
        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'REPORTE INFORMES - guarda datos en plantilla para generar los informes.
    '-----------------------------------------------------
    Public Shared Function CloneInforme(ByVal NTransaccion As Integer, ByVal Periodo As String, ByVal codTransaccion As String, ByVal Linea As Integer, ByVal codMaterial As String,
                ByVal nombreMaterial As String, ByVal CodItem As String, ByVal cantMaterial As Integer, ByVal precioMaterial As Single, ByVal Bodega As String,
                ByVal descripcion As String, ByVal fechaMovimieno As DateTime, ByVal proveedor As String, ByVal OrdenCompra As Integer, ByVal ordenCompraEstado As String,
                ByVal numeroDocumento As Integer, ByVal Institucion As String, ByVal centroCosto As String, ByVal tipoDocumento As String, ByVal tituloMenu As String,
                ByVal descuento As Single, ByVal impuesto As Single, ByVal diferenciaPeso As Single, ByVal usuario As String)

        Dim respuesta As New Dictionary(Of String, String)
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_INFORME_TRANSACCIONES_INS_net")

            comando.Parameters.Add(New SqlParameter("@FLD_NROTRANSACCION", NTransaccion))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", Periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", codTransaccion))
            comando.Parameters.Add(New SqlParameter("@FLD_LINEA", Linea))
            comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codMaterial))

            comando.Parameters.Add(New SqlParameter("@FLD_MATNOMBRE", nombreMaterial))
            comando.Parameters.Add(New SqlParameter("@FLD_ITECODIGO", CodItem))
            comando.Parameters.Add(New SqlParameter("@FLD_CANTIDAD", cantMaterial))
            comando.Parameters.Add(New SqlParameter("@FLD_PRECIOUNITARIO", precioMaterial))
            comando.Parameters.Add(New SqlParameter("@FLD_BODEGA", Bodega))

            comando.Parameters.Add(New SqlParameter("@FLD_OBSERVACION", descripcion))
            comando.Parameters.Add(New SqlParameter("@FLD_FECHA", fechaMovimieno))
            comando.Parameters.Add(New SqlParameter("@FLD_PROVEEDOR", proveedor))
            comando.Parameters.Add(New SqlParameter("@FLD_ORDENCOMPRA", OrdenCompra))
            comando.Parameters.Add(New SqlParameter("@FLD_OCOESTADO", ordenCompraEstado))

            comando.Parameters.Add(New SqlParameter("@FLD_NRODOCUMENTO", numeroDocumento))
            comando.Parameters.Add(New SqlParameter("@FLD_INSTITUCION", Institucion))
            comando.Parameters.Add(New SqlParameter("@FLD_CENTRO_COSTO", centroCosto))
            comando.Parameters.Add(New SqlParameter("@FLD_TIPODOCUMENTO", tipoDocumento))
            comando.Parameters.Add(New SqlParameter("@FLD_TITULO", tituloMenu))

            comando.Parameters.Add(New SqlParameter("@FLD_DESCUENTO", descuento))
            comando.Parameters.Add(New SqlParameter("@FLD_IMPUESTO", impuesto))
            comando.Parameters.Add(New SqlParameter("@FLD_DIFPESO", diferenciaPeso))
            comando.Parameters.Add(New SqlParameter("@FLD_USUARIO", usuario))

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                respuesta.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                respuesta.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                respuesta.Add("FLD_TMVCODIGO", Convert.ToString(lector("FLD_TMVCODIGO")))
                respuesta.Add("FLD_USUARIO", Convert.ToString(lector("FLD_USUARIO")))
                respuesta.Add("ERROR", Convert.ToString(lector("ERROR")))

            End While

            dataBase.cerrar_Conexion()

            Return respuesta

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            respuesta.Add("FLD_CMVNUMERO", "0")
            respuesta.Add("ERROR", ex.Message)
            Return respuesta
        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'REPORTE INFORMES - guarda datos en plantilla para generar los informes.
    '-----------------------------------------------------
    Public Shared Function saveData_RPT_NroFacturaOC(ByVal Periodo As String, ByVal NroOC As Integer, ByVal NroRecep As Integer)

        Dim respuesta As New Dictionary(Of String, String)
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_TB_ORDENESCOMPRA_SEL_OCxNroFactura_NEW2015")

            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", Periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_OCONUMERO", NroOC))
            comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", NroRecep))

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                respuesta.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                respuesta.Add("FLD_PERCODIGO", Convert.ToString(lector("FLD_PERCODIGO")))
                respuesta.Add("FLD_TMVCODIGO", Convert.ToString(lector("FLD_TMVCODIGO")))
                respuesta.Add("ERROR", Convert.ToString(lector("ERROR")))

            End While

            dataBase.cerrar_Conexion()

            Return respuesta

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            respuesta.Add("FLD_CMVNUMERO", "0")
            respuesta.Add("ERROR", ex.Message)
            Return respuesta
        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Universal - Verifica si el detalle ingresado en el despacho es equivalente a un material del sistema para su despacho.
    '-----------------------------------------------------
    Public Shared Function validaSiExisteElMaterial(ByVal codMaterial As String, ByVal Bodega As String, ByVal Nserie As String, ByVal tipoMovimiento As Integer)

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim respuesta As New Dictionary(Of String, String)


        Try

            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_VALIDA_DETALLE_MATERIAL_NET2015")
            Dim validate As String = ""

            comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codMaterial))
            comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", Bodega))
            comando.Parameters.Add(New SqlParameter("@FLD_SERIE", Nserie))
            comando.Parameters.Add(New SqlParameter("@TIPO_MOV", tipoMovimiento))

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                respuesta.Add("FLD_MOVCANTIDAD", Convert.ToString(lector("FLD_MOVCANTIDAD")))
                respuesta.Add("FLD_FECHAVENCIMIENTO", Convert.ToString(lector("FLD_FECHAVENCIMIENTO")))
                respuesta.Add("validate", Convert.ToString(lector("validate")))

            End While

            dataBase.cerrar_Conexion()

            Return respuesta

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            respuesta.Add("validate", "1")
            respuesta.Add("ERROR", ex.Message)
            Return respuesta
        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    ' Universal - Verifica que el NSerie ingresado no este presente en la BD.
    '----------------------------------------------------- 
    Public Shared Function validaNserie(ByVal Bodega As String, ByVal codMaterial As String, ByVal Nserie As String)

        Dim dataBase As BaseDatos = getBaseDatos()
        Dim respuesta As New Dictionary(Of String, String)

        Try

            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_CONTROL_NSERIE_NET2015")
            Dim validate As String = ""

            ' comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", tmvCodigo))
            comando.Parameters.Add(New SqlParameter("@FLD_BODCODIGO", Bodega))
            comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", codMaterial))
            comando.Parameters.Add(New SqlParameter("@FLD_NSERIE", Nserie))

            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()
                ' 0 no existe, 1 problema si existe.
                respuesta.Add("validate", Convert.ToString(lector("EXISTE")))

            End While

            dataBase.cerrar_Conexion()

            Return respuesta

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            respuesta.Add("validate", "1")
            respuesta.Add("ERROR", ex.Message)
            Return respuesta
        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    ' Universal NUEVO - carga cantidad de QR - new NOV 2015
    '-----------------------------------------------------
    Public Shared Function Insertar_CantidadQR(ByVal CodMaterial As String, ByVal NSerie As String, ByVal CantImprimir As String, ByVal Periodo As String,
                                               ByVal NumMov As Integer, ByVal CodMov As String)

        Dim respuesta As New Dictionary(Of String, String)
        Dim dataBase As BaseDatos = getBaseDatos()

        Try

            ' Conectar a BD
            dataBase.Conectar_Sin_Datos()
            Dim comando As SqlCommand = dataBase.crearComando("BD_ABASTECIMIENTO..PRO_CANTIDAD_QR_INS_new2015")

            comando.Parameters.Add(New SqlParameter("@FLD_MATCODIGO", CodMaterial))
            comando.Parameters.Add(New SqlParameter("@FLD_NSERIE", NSerie))
            comando.Parameters.Add(New SqlParameter("@FLD_PERCODIGO", Periodo))
            comando.Parameters.Add(New SqlParameter("@FLD_TMVCODIGO", CodMov))
            comando.Parameters.Add(New SqlParameter("@FLD_CMVNUMERO", NumMov))
            comando.Parameters.Add(New SqlParameter("@FLD_MOVCANTIDAD", CantImprimir))
            Dim lector As SqlDataReader = comando.ExecuteReader()

            While lector.Read()

                respuesta.Add("FLD_CMVNUMERO", Convert.ToString(lector("FLD_CMVNUMERO")))
                respuesta.Add("ERROR", Convert.ToString(lector("ERROR")))

            End While

            dataBase.cerrar_Conexion()

            Return respuesta

        Catch ex As Exception

            dataBase.cerrar_Conexion()
            respuesta.Add("FLD_CMVNUMERO", "0")
            respuesta.Add("ERROR", ex.Message)
            Return respuesta
        End Try

    End Function
    '-----------------------------------------------------
    '-----------------------------------------------------
    'Obtiene la instancia de la base de datos creada
    '-----------------------------------------------------
    Public Shared Function getBaseDatos() As BaseDatos
        Return System.Web.HttpContext.Current.Session("baseDatos")
    End Function
    '-----------------------------------------------------
End Class