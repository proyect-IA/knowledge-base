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
        /// Método que permite obtener la mejor desición dados los recursos disponibles
        /// </summary>
        /// <param name="ia"></param>
        /// <param name="enemiga"></param>
        /// <returns></returns>
        public static string obtenerNuevoEstado(InfoUnidad ia, InfoUnidad enemiga)
        {
            //Construccion del nodo raíz
            Nodo raiz    = new Nodo();
            raiz.enemiga = enemiga;
            raiz.unidad  = ia;
            raiz.funcion_generadora = "top";
            raiz.nivel    = 0;
            raiz.visitado = false;
            raiz.hijos    = new List<Nodo>();

            //Generación del arbol de busqueda
            raiz = Servicios.ServiciosArbol.construirArbol(raiz);

            //Busqueda en el arbol con DFS 
            List<Nodo> mejorRutaAcciones = new List<Nodo>();
            mejorRutaAcciones            = obtenerCaminoSolucion(raiz);

            return mejorRutaAcciones[0].funcion_generadora;
        }

        /// <summary>
        /// Método que construye el árbol de busqueda, con todas las posibles acciones
        /// </summary>
        /// <param name="amiga"></param>
        /// <param name="enemiga"></param>
        /// <returns></returns>
        
        public static Nodo construirArbol(Nodo raiz)
        {
            int nivelMaximo = 3;

            if (raiz.funcion_generadora == "Retirada")
                return raiz;
            if (raiz.funcion_generadora == "Exito")
                return raiz;


            generarHijos(raiz);
            foreach (Nodo i in raiz.hijos)
                if(raiz.nivel <= nivelMaximo)
                    construirArbol(i);

            return raiz;
        }


        /// <summary>
        /// Método que obtiene el camino solución
        /// </summary>
        /// <returns></returns>
        public static List<Nodo> obtenerCaminoSolucion(Nodo raiz)
        {
            //Implementanción de DFS para recuperar la mejor solución
            List<Nodo> caminoSolucion = new List<Nodo>();
            float superioridad_ia       = 0.0f;
            Nodo n = new Nodo();
            Stack<Nodo> path = new Stack<Nodo>();

            // Se ingresa el nodo raíz
            path.Push(raiz);
            while(path.Count >0)
            {
                Nodo peak = path.Pop();
                peak.visitado = true;
                // Obtiene el nodo con mayor superioridad
                foreach (Nodo hijo in peak.hijos)
                {
                    if (hijo.visitado == false && hijo.unidad.superioridad > superioridad_ia)
                    {
                        n = hijo;
                        superioridad_ia = hijo.unidad.superioridad;
                    }
                    //Console.WriteLine("Acciones   hijo: " + hijo.funcion_generadora);
                    //Console.WriteLine("   superioridad: " + hijo.unidad.superioridad);
                }
                caminoSolucion.Add(n);
            }
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

            //Console.WriteLine("Superioridad:   " + superioridad);
            return superioridad;
        }



        public static bool generarHijos(Nodo nodo)
        {
            /// Genera los posibles hijos desde un nodo.
            /// Las posibles acciones son:  
            /// [Ataque directo, Ataque indirecto, segregar, retirada, movilizarte]
            int threshold_distance = 500;
            Random rnd = new Random();
            // private static int threshold = 500;

            // Caso base del algoritmo
            if (nodo.funcion_generadora == "Retirada")
                return false;
            if (nodo.unidad.superioridad > 1.0f)
                return false;
            if (nodo.unidad.superioridad < 0.0f)
                return false;

            // Genera nodo hijo con accion desplazamiento
            if (nodo.unidad.distancia_entre_elementos > threshold_distance)
            {
                // Genera nodo hijo con accion ataque indirecto
                Nodo n1 = new Nodo();
                n1.unidad = obtenerCopia(nodo.unidad);
                n1.enemiga = obtenerCopia(nodo.enemiga);
                n1.visitado = false;
                n1.hijos = new List<Nodo>();
                n1.enemiga.elementos -= 200;
                n1.unidad.recursos -= 1;
                n1.funcion_generadora = "Ataque Indirecto";
                n1.unidad.superioridad = calcularSuperioridad(n1.unidad, n1.enemiga);
                n1.nivel = nodo.nivel + 1;
                nodo.hijos.Add(n1);

                Nodo n2 = new Nodo();
                n2.unidad = obtenerCopia(nodo.unidad);
                n2.enemiga = obtenerCopia(nodo.enemiga);
                n2.visitado = false;
                n2.hijos = new List<Nodo>();
                n2.unidad.distancia_entre_elementos -= 100;
                n2.funcion_generadora = "Desplazamiento";
                n2.unidad.superioridad = calcularSuperioridad(n2.unidad, n2.enemiga) + (float)rnd.Next(-100, 100)/500;
                n2.nivel = nodo.nivel +1;
                nodo.hijos.Add(n2);
            }
            else
            {
                // Genera nodo hijo con accion ataque directo
                Nodo n3 = new Nodo();
                n3.unidad = obtenerCopia(nodo.unidad);
                n3.enemiga = obtenerCopia(nodo.enemiga);
                n3.visitado = false;
                n3.hijos = new List<Nodo>();
                n3.enemiga.elementos += 40;
                n3.unidad.recursos -= 1;
                n3.funcion_generadora = "Ataque directo";
                n3.unidad.superioridad = calcularSuperioridad(n3.unidad, n3.enemiga);
                n3.nivel = nodo.nivel + 1;
                nodo.hijos.Add(n3);
            }

            if (nodo.unidad.superioridad < 0.3)
            {
                // Genera nodo hijo con accion ataque directo
                Nodo n4 = new Nodo();
                n4.unidad = obtenerCopia(nodo.unidad);
                n4.enemiga = obtenerCopia(nodo.enemiga);
                n4.visitado = false;
                n4.hijos = new List<Nodo>();
                n4.funcion_generadora = "Retirada";
                n4.unidad.superioridad = 0.99f;
                n4.nivel = nodo.nivel + 1;
                nodo.hijos.Add(n4);
           }

            if (nodo.unidad.superioridad > 0.7)
            {
                Nodo n5 = new Nodo();
                n5.unidad = obtenerCopia(nodo.unidad);
                n5.enemiga = obtenerCopia(nodo.enemiga);
                n5.visitado = false;
                n5.hijos = new List<Nodo>();
                n5.funcion_generadora = "Exito";
                n5.unidad.superioridad = 0.99f;
                n5.nivel = nodo.nivel + 1;
                nodo.hijos.Add(n5);
            }

            // Genera nodo hijo con segregación
            /*
            if (nodo.unidad.elementos > threshold_elements)
            {
                Nodo n2 = new Nodo();
                n2.unidad   = obtenerCopia(nodo.unidad);
            }
            */
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
