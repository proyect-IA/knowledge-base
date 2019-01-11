using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WpfApplication1.Eventos
{
    public class EventoCambioEstado : EventArgs
    {
        public EventoCambioEstado()
        {

        }
    }

    public class PublicadorEventoCambioEstado
    {
        public event EventHandler<EventoCambioEstado> eventoCambio;
        private static PublicadorEventoCambioEstado instancia;

        private PublicadorEventoCambioEstado() { }

        public static PublicadorEventoCambioEstado obtenerInstancia()
        {
            if (instancia == null)
            {
                instancia = new PublicadorEventoCambioEstado();
            }

            return instancia;
        }

        public void LanzarEvento(object lanzador, EventoCambioEstado evento)
        {
            OnRaiseCustomEvent(lanzador, evento);
        }

        private void OnRaiseCustomEvent(object lanzador, EventoCambioEstado evento)
        {
            EventHandler<EventoCambioEstado> handler = eventoCambio;

            if (handler != null)
            {
                handler(lanzador, evento);
            }
        }
    }
}
