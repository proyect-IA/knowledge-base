using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;
using WpfApplication1.Interfaces;

namespace WpfApplication1.Estados
{
    public class Retirada : IAccionAutonoma
    {
        /// <summary>
        /// Propiedad que permite ejecutar una acción autonoma
        /// </summary>
        public Canvas ejecutarAccionAutonomo(ControlVisualSimulacion c)
        {
            return c.canvas;
        }

        /// <summary>
        /// Método que permite restablecer el estado actual desplazamiento
        /// </summary>
        public void restablecerAccion()
        {
        }
    }
}
