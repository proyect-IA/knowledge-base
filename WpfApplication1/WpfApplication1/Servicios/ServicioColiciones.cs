using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WpfApplication1.Informacion;

namespace WpfApplication1.Servicios
{
    public class ServicioColiciones
    {

        public static bool verificarColicion(Unidad autonoma, Unidad enemiga, int radio)
        {
            int distancia = (int)Math.Sqrt((int)Math.Pow(autonoma.x - enemiga.x, 2) + (int)Math.Pow(autonoma.y - enemiga.y, 2));

            if (distancia <= radio)
            {
                return true;
            }

            return false;
        }

        /// <summary>
        /// Método que permite obtener la distancia entre dos puntos
        /// </summary>
        /// <param name="autonoma"></param>
        /// <param name="enemiga"></param>
        /// <returns></returns>
        public static int obtenerDistanciaEntrePuntos(Unidad autonoma, Unidad enemiga)
        {
            return (int)Math.Sqrt((int)Math.Pow(autonoma.x - enemiga.x, 2) + (int)Math.Pow(autonoma.y - enemiga.y, 2));
        }

    }
}
