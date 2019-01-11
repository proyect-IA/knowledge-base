using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WpfApplication1.Informacion
{
    public class Unidad
    {
        public int personal { get; set; }

        /// <summary>
        /// Propiedad que indica la cantidad de muertos
        /// </summary>
        public int muertos  { get; set; }
        public Accion estadoActual { get; set; }
        public int x { get; set; }
        public int y { get; set; }
        public int nivel_operatividad { get; set; }

        public string accionActual
        {
            get
            {
                string valor = "";

                switch (estadoActual)
                {
                    case Accion.MOVERCE:
                        valor = "desplazamiento";
                        break;

                    case Accion.SEGREGAR:
                        valor = "segregando";
                        break;

                    case Accion.ATACAR_DIRECTO:
                    case Accion.ATAQUE_INDIRECTO:
                        valor = "atacando";
                        break;
                }

                return valor.ToUpper();
            }
        }

        public string estado
        {
            get
            {
                string valor = "";

                if(nivel_operatividad < 50 )
                {
                    valor = "rojo";
                }
                else if (nivel_operatividad > 70 && nivel_operatividad < 80)
                {
                    valor = "naranja";
                }
                else
                {
                    valor = "verde";
                }


                return valor;
            }
        }
    }
}
