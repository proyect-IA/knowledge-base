using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;
using System.Windows.Shapes;

namespace WpfApplication1.Servicios
{
    public class ServicioDibujar
    {
        private static Rectangle rec = new Rectangle();

        public static void dibujarLienzo(Canvas lienzo)
        {           
            Canvas.SetLeft(rec, 100);
            Canvas.SetTop(rec, 100);

            lienzo.Children.Add(rec);
        }
    }
}
