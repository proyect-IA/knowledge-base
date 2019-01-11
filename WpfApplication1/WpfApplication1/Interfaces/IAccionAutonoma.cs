using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;
using WpfApplication1.Informacion;

namespace WpfApplication1.Interfaces
{
    public interface IAccionAutonoma
    {
        /// <summary>
        /// Método que permite ejecutar la acción autonoma
        /// </summary>
        Canvas ejecutarAccionAutonomo(ControlVisualSimulacion c);

        void restablecerAccion();

        
    }
}
