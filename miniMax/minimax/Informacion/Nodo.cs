using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace minimax.Informacion
{
    public class Nodo
    {
        public int numero_elementos;
        public int nivel_elementos;
        public int numero_armas;
        public int nivel_armas;
        public int numero_elementos_enemigo;
        public int nivel_elementos_enemigo;
        public int numero_armas_enemigo;
        public int nivel_armas_enemigo;
        public int superioridad;
        public int padre;

        public Nodo()
        {
            this.numero_elementos = 0;
            this.nivel_elementos = 0;
            this.numero_armas = 0;
            this.nivel_armas = 0;
            this.numero_elementos_enemigo = 0;
            this.nivel_elementos_enemigo = 0;
            this.numero_armas_enemigo = 0;
            this.nivel_armas_enemigo = 0;
            this.superioridad = 0;
            this.padre = 0;
        }
    }
}
