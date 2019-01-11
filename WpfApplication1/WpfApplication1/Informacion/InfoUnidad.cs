using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WpfApplication1.Informacion
{
    public class InfoUnidad
    {
        /// <summary>
        /// Contiene el número de elementos
        /// </summary>
        public int elementos                   { get; set; }

        /// <summary>
        /// Propiedad que indica el numero de armas
        /// </summary>
        public int armas                       { get; set; }

        /// <summary>
        /// propiedad que indica el nivel de armas
        /// </summary>
        public int nivel_armas                 { get; set; }

        /// <summary>
        /// propiedad que indica el niverl de recursos
        /// </summary>
        public float recursos                  { get; set; }

        /// <summary>
        /// propiedad que indica el niverl de recursos
        /// </summary>
        public float distancia_entre_elementos { get; set; }

        /// <summary>
        /// Propiedad que indica el nivel de superioridad
        /// </summary>
        public float superioridad              { get; set; }
    }
}
