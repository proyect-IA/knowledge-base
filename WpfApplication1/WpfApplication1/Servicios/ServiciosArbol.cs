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
                    Console.WriteLine("Acciones   hijo: " + hijo.funcion_generadora);
                    Console.WriteLine("   superioridad: " + hijo.unidad.superioridad);
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

            Console.WriteLine("Superioridad:   " + superioridad);
            return superioridad;
        }



        public static bool generarHijos(Nodo nodo)
        {
            /// Genera los posibles hijos desde un nodo.
            /// Las posibles acciones son:  
            /// [Ataque directo, Ataque indirecto, segregar, retirada, movilizarte]
            int threshold_distance = 500;
            float threshold_elements = 500;
            // private static int threshold = 500;

            // Caso base del algoritmo
            if (nodo.funcion_generadora == "Retirada")
                return false;
            if (nodo.unidad.superioridad > 0.8f)
                return false;
            if (nodo.unidad.superioridad < 0.0f)
                return false;


            Nodo n1     = new Nodo();
            n1.unidad   = obtenerCopia(nodo.unidad);
            n1.enemiga  = obtenerCopia(nodo.enemiga);
            n1.visitado = false;
            n1.hijos    = new List<Nodo>();

            // Genera nodo hijo con accion desplazamiento
            if (nodo.unidad.distancia_entre_elementos > threshold_distance)
            {
                n1.unidad.distancia_entre_elementos -= 100;
                n1.funcion_generadora = "Desplazamiento";
                n1.unidad.superioridad = calcularSuperioridad(n1.unidad, n1.enemiga);
                n1.nivel = nodo.nivel +1;
                nodo.hijos.Add(n1);

                // Genera nodo hijo con accion ataque indirecto
                n1.unidad.distancia_entre_elementos += 100;
                n1.enemiga.elementos -= 200;
                n1.unidad.recursos -= 1;
                n1.funcion_generadora = "Ataque Indirecto";
                n1.unidad.superioridad = calcularSuperioridad(n1.unidad, n1.enemiga);
                n1.nivel = nodo.nivel + 1;
                nodo.hijos.Add(n1);
            }
            else
            {
                // Genera nodo hijo con accion ataque directo
                n1.enemiga.elementos += 40;
                n1.unidad.recursos -= 1;
                n1.funcion_generadora = "Ataque directo";
                n1.unidad.superioridad = calcularSuperioridad(n1.unidad, n1.enemiga);
                n1.nivel = nodo.nivel + 1;
                nodo.hijos.Add(n1);
            }

            if (nodo.unidad.superioridad < 0.3)
            {
                Nodo n2   = new Nodo();
                n2.unidad = obtenerCopia(nodo.unidad);
                n2.funcion_generadora = "Retirada";
                n2.hijos = new List<Nodo>();
                nodo.hijos.Add(n2);
            }

            if (nodo.unidad.superioridad > 0.7)
            {
                Nodo n2 = new Nodo();
                n2.unidad = obtenerCopia(nodo.unidad);
                n2.funcion_generadora = "Exito";
                n2.hijos = new List<Nodo>();
                nodo.hijos.Add(n2);
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
