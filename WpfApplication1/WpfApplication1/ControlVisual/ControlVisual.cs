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
        public void iniciarConstruccionDeArbol()
        {
            //carga la situación de la unidad ia
            InfoUnidad ia  = new InfoUnidad();
            ia.elementos   = Convert.ToInt32(_vista.elemento.Text);
            ia.armas       = Convert.ToInt32(_vista.armas.Text);
            ia.nivel_armas = Convert.ToInt32(_vista.nivel_armas.Text);
            ia.recursos    = Convert.ToInt32(_vista.recursos.Text);

            //carga la situación de la unidad enemiga
            InfoUnidad enemiga  = new InfoUnidad();
            enemiga.elementos   = Convert.ToInt32(_vista.elemento_ia.Text);
            enemiga.armas       = Convert.ToInt32(_vista.armas_ia.Text);
            enemiga.nivel_armas = Convert.ToInt32(_vista.nivel_armas_ia.Text);
            enemiga.recursos    = Convert.ToInt32(_vista.recursos_ia.Text);

        }


        public void correrSimulacionIA()
        {

        }


    }
}
