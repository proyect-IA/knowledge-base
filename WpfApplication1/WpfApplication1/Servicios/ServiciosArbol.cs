using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WpfApplication1.Informacion;

namespace WpfApplication1.Servicios
{
    public class ServiciosArbol
    {
        /// <summary>
        /// Método que construye el árbol de busqueda, con todas las posibles acciones
        /// </summary>
        /// <param name="amiga"></param>
        /// <param name="enemiga"></param>
        /// <returns></returns>
        public static Nodo iniciarConstruccionArbol(InfoUnidad amiga, InfoUnidad enemiga)
        {
            Nodo raiz = new Nodo();

            return raiz;
        }


        /// <summary>
        /// Método que obtiene el camino solución
        /// </summary>
        /// <returns></returns>
        public static List<NodoSolucion> obtenerCaminoSolucion()
        {
            //Lista del camino solución
            List<NodoSolucion> caminoSolucion = new List<NodoSolucion>();

            return caminoSolucion;
        }
    }
}
