using System;
using System.Collections.Generic;
using System.Diagnostics;
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

        public static float calcularSuperioridad(InfoUnidad amiga, InfoUnidad enemiga)
        {
            //Lista del camino solución
            float superioridad     = 0.5f;
            float diff_elements    = amiga.elementos - enemiga.elementos;
            float diff_armas       = amiga.armas - enemiga.armas;
            float diff_nivel_armas = amiga.nivel_armas - enemiga.nivel_armas;

            superioridad += (0.5f / 3) * (diff_elements / (amiga.elementos + enemiga.elementos));
            superioridad += (0.5f / 3) * (diff_armas / (amiga.armas + enemiga.armas));
            superioridad += (0.5f / 3) * (diff_nivel_armas / (amiga.nivel_armas + enemiga.nivel_armas));

            Console.WriteLine("Superioridad:   " + superioridad);
            return superioridad;
        }


        public static bool generarHijos(Nodo nodo)
        {
            /// Genera los posibles hijos desde un nodo.
            /// Las posibles acciones son:  
            /// [Ataque directo, Ataque indirecto, segregar, retirada, movilizarte]
            
            Nodo n1 = new Nodo();
            n1.unidad = obtenerCopia(nodo.unidad);
            nodo.hijos.Add(n1);

            Nodo n2 = nodo;
            nodo.hijos.Add(n2);

            Nodo n3 = nodo;
            nodo.hijos.Add(n3);

            Nodo n4 = nodo;
            nodo.hijos.Add(n4);

            Nodo n5 = nodo;
            nodo.hijos.Add(n5);

            return true;
        }

        public static InfoUnidad obtenerCopia(InfoUnidad uni)
        {
            InfoUnidad copia = new InfoUnidad();
            copia.elementos                 = uni.elementos;
            copia.armas                     = uni.armas;
            copia.nivel_armas               = uni.nivel_armas;
            copia.recursos                  = uni.recursos;
            copia.distancia_entre_elementos = uni.distancia_entre_elementos;
            copia.superioridad              = uni.superioridad;

            return copia;
        } 
    }
}
