using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WpfApplication1.Informacion;

namespace WpfApplication1
{
    public class ControlVisual
    {
        public MainWindow _vista { get; set; }

        /// <summary>
        /// Constructor de la clase
        /// </summary>
        public ControlVisual(MainWindow vista)
        {
            this._vista = vista;
        }
        
        /// <summary>
        /// Método que inicia con la construcción del árbol
        /// </summary>
        public void obtenerInformacionDeArbol()
        {
            //carga la situación de la unidad ia
            InfoUnidad ia  = new InfoUnidad();
            ia.elementos   = Convert.ToInt32(_vista.elemento.Text);
            ia.armas       = Convert.ToInt32(_vista.armas.Text);
            ia.nivel_armas = Convert.ToInt32(_vista.nivel_armas.Text);
            ia.recursos    = Convert.ToInt32(_vista.recursos.Text);

            //carga la situación de la unidad enemiga
            InfoUnidad enemiga  = new InfoUnidad();
            enemiga.elementos   = Convert.ToInt32(_vista.elemento.Text);
            enemiga.armas       = Convert.ToInt32(_vista.armas.Text);
            enemiga.nivel_armas = Convert.ToInt32(_vista.nivel_armas.Text);
            enemiga.recursos    = Convert.ToInt32(_vista.recursos.Text);

            ia.superioridad = Servicios.ServiciosArbol.calcularSuperioridad(ia, enemiga);
            enemiga.superioridad = 1.0f - ia.superioridad;
            Console.WriteLine("Superioridad IA:  " + ia.superioridad);
            Console.WriteLine("Superioridad Enemigo:  " + enemiga.superioridad);

            //Construccion del nodo raíz
            Nodo raiz = new Nodo();
            raiz.enemiga = enemiga;
            raiz.unidad = ia;
            raiz.funcion_generadora = "top";
            raiz.nivel = 0;
            raiz.visitado = false;
            raiz.hijos = new List<Nodo>();

            //Generación del arbol de busqueda
            raiz = Servicios.ServiciosArbol.construirArbol(raiz);

            cargarDatosUnidades(ia, enemiga);

            _vista.btnIniciar.IsEnabled = true;
        }

        public void cargarDatosUnidades(InfoUnidad ia, InfoUnidad enem)
        {
            _vista.controlVisualLienzo.autonoma.personal = ia.elementos;
            _vista.controlVisualLienzo.enemiga.personal = enem.elementos;
        }




        public void correrSimulacionIA()
        {

        }


    }
}
